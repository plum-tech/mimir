import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mimir/game/utils.dart';
import '../model/fruit.dart';
import '../entity/fruit.dart';
import '../entity/wall.dart';
import '../model/wall.dart';
import '../presenter/dialog_presenter.dart';
import '../presenter/next_text_presenter.dart';
import '../presenter/prediction_line_presenter.dart';
import '../presenter/score_presenter.dart';
import '../presenter/world_presenter.dart';
import '../repository/game_repository.dart';
import '../rule/next_size_fruit.dart';
import '../rule/score_calculator.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../ui/main_game.dart';

typedef ScreenCoordinateFunction = Vector2 Function(Vector2);
typedef ComponentFunction = FutureOr<void> Function(Component);

class GameState {
  GameState({
    required this.worldToScreen,
    required this.screenToWorld,
    required this.camera,
    required this.add,
  });

  final ScreenCoordinateFunction worldToScreen;
  final ScreenCoordinateFunction screenToWorld;
  final ComponentFunction add;
  final CameraComponent camera;

  /// where to drop fruit
  double? draggingPosition;
  FruitEntity? draggingFruit;
  FruitEntity? nextFruit;

  bool isDragEnd = false;

  int overGameOverLineCount = 0;

  bool isGameOver = false;

  GameRepository get _gameRepository => GetIt.I.get<GameRepository>();

  WorldPresenter get _worldPresenter => GetIt.I.get<WorldPresenter>();

  ScorePresenter get _scorePresenter => GetIt.I.get<ScorePresenter>();

  NextTextPresenter get _nextTextPresenter => GetIt.I.get<NextTextPresenter>();

  PredictionLinePresenter get _predictLinePresenter => GetIt.I.get<PredictionLinePresenter>();

  DialogPresenter get _dialogPresenter => GetIt.I.get<DialogPresenter>();

  void onLoad() {
    // Add wall
    _worldPresenter
      ..add(
        WallEntity(
          wall: Wall(
            pos: center + Vector2(screenSize.x, 0),
            size: Vector2(1, screenSize.y),
          ),
        ),
      )
      ..add(
        WallEntity(
          wall: Wall(
            pos: center - Vector2(screenSize.x, 0),
            size: Vector2(1, screenSize.y),
          ),
        ),
      )
      ..add(
        WallEntity(
          wall: Wall(
            pos: center + Vector2(0, screenSize.y),
            size: Vector2(screenSize.x + 1, 1),
          ),
        ),
      );
    _scorePresenter.position = worldToScreen(
      center - Vector2(screenSize.x + 1, screenSize.y + 13),
    );
    _nextTextPresenter.position = worldToScreen(
      center - Vector2(-screenSize.x + 5, screenSize.y + 13),
    );

    final rect = camera.visibleWorldRect;
    draggingPosition = (rect.left + rect.right) / 2;
    draggingFruit = FruitEntity(
      fruit: Fruit.$1(
        id: const Uuid().v4(),
        pos: Vector2(
          draggingPosition!,
          -screenSize.y + center.y - FruitType.$1.radius,
        ),
      ),
      isStatic: true,
    );
    _worldPresenter.add(draggingFruit!);
    final newNextFruit = _getNextFruit();
    nextFruit = FruitEntity(
      fruit: newNextFruit.copyWith(
        pos: Vector2(
          screenSize.x - 2,
          -screenSize.y + center.y - 7,
        ),
      ),
      overrideRadius: 2,
      isStatic: true,
    );
    _worldPresenter.add(nextFruit!);
  }

  void onUpdate() {
    if (isGameOver) {
      return;
    }
    _countOverGameOverLine();
    if (overGameOverLineCount > 100) {
      isGameOver = true;
      final score = _scorePresenter.score;
      _dialogPresenter.showGameOverDialog(score);
    }

    if (isDragEnd) {
      onDragEnd();
      isDragEnd = false;
    }
    _handleCollision();
  }

  void _handleCollision() {
    final collidedFruits = _gameRepository.getCollidedFruits();
    if (collidedFruits.isEmpty) return;

    for (final collideFruit in collidedFruits) {
      final fruit1 = collideFruit.fruit1.userData! as FruitEntity;
      final fruit2 = collideFruit.fruit2.userData! as FruitEntity;
      final newFruit = _getNextSizeFruit(
        fruit1: fruit1,
        fruit2: fruit2,
      );
      _scorePresenter.addScore(
        getScore(
          newFruit,
        ),
      );

      _worldPresenter
        ..remove(fruit1)
        ..remove(fruit2);
      if (newFruit != null) {
        _worldPresenter.add(
          FruitEntity(
            fruit: newFruit,
          ),
        );
        applyGameHapticFeedback();
      }
    }
    _gameRepository.clearCollidedFruits();
  }

  void onDragUpdate(int pointerId, Vector2 global) {
    final pos = screenToWorld(global);
    final draggingPositionX = _adjustDraggingPositionX(pos.x);
    _onDraggingPositionChanged(draggingPositionX);
  }

  void _onDraggingPositionChanged(double newX) {
    draggingPosition = newX;
    final rect = camera.visibleWorldRect;
    // Update the predict line
    _predictLinePresenter.updateLine(
      worldToScreen(Vector2(newX, rect.top)),
      worldToScreen(Vector2(newX, rect.bottom)),
    );
    if (draggingFruit?.isMounted != null && draggingFruit!.isMounted) {
      draggingFruit?.body.setTransform(
        Vector2(
          newX,
          -screenSize.y + center.y - draggingFruit!.fruit.radius,
        ),
        0,
      );
    }
  }

  Future<void> onDragEnd() async {
    if (draggingFruit == null) return;
    _dropFruit();
    await Future.delayed(const Duration(seconds: 1));
    _createDraggingFruit();
  }

  Future<void> onTap(double globalX) async {
    if (draggingFruit == null) return;
    final pos = screenToWorld(Vector2(globalX, 0));
    final x = _adjustDraggingPositionX(pos.x);
    _onDraggingPositionChanged(x);
    _dropFruit();
    await Future.delayed(const Duration(seconds: 1));
    _createDraggingFruit();
  }

  void _dropFruit() {
    if (draggingFruit == null) return;
    _worldPresenter.remove(draggingFruit!);
    final fruit = draggingFruit!.fruit;
    final draggingPositionX = _adjustDraggingPositionX(draggingPosition!);
    final newFruit = fruit.copyWith(
      pos: Vector2(
        draggingPositionX,
        -screenSize.y + center.y - fruit.radius,
      ),
    );
    _worldPresenter.add(
      FruitEntity(
        fruit: newFruit,
      ),
    );
    draggingFruit = null;
  }

  void _createDraggingFruit() {
    final draggingPositionX = _adjustDraggingPositionX(draggingPosition!);
    draggingFruit = FruitEntity(
      fruit: nextFruit!.fruit.copyWith(
        pos: Vector2(
          draggingPositionX,
          -screenSize.y + center.y - nextFruit!.fruit.radius,
        ),
      ),
      isStatic: true,
    );
    _worldPresenter
      ..remove(nextFruit!)
      ..add(draggingFruit!);
    final newNextFruit = _getNextFruit();
    nextFruit = FruitEntity(
      fruit: newNextFruit.copyWith(
        pos: Vector2(
          screenSize.x - 2,
          -screenSize.y + center.y - 7,
        ),
      ),
      overrideRadius: 2,
      isStatic: true,
    );
    _worldPresenter.add(nextFruit!);
  }

  void reset() {
    _worldPresenter.clear();
    _gameRepository.clearCollidedFruits();
    _scorePresenter.reset();
    draggingPosition = null;
    draggingFruit = null;
    nextFruit = null;
    isGameOver = false;
    onLoad();
  }

  double _adjustDraggingPositionX(double x) {
    final fruitRadius = draggingFruit?.fruit.radius ?? 1;
    if (x < screenSize.x * -1 + fruitRadius + 1) {
      return screenSize.x * -1 + fruitRadius + 1;
    }
    if (x > screenSize.x - fruitRadius - 1) {
      return screenSize.x - fruitRadius - 1;
    }
    return x;
  }

  void _countOverGameOverLine() {
    final components = _worldPresenter.getComponents();
    final fruits = components.whereType<FruitEntity>();
    final dynamicFruits = fruits.where((fruit) => !fruit.isStatic);
    final minY = dynamicFruits.fold<double>(
      0,
      (previousValue, element) => min(previousValue, element.body.position.y + center.y + 2.25),
    );
    if (minY < 0) {
      overGameOverLineCount++;
    } else {
      overGameOverLineCount = 0;
    }
  }

  void onCollidedSameSizeFruits({
    required Body bodyA,
    required Body bodyB,
  }) {
    GetIt.I.get<GameRepository>().addCollidedFruits(
          CollidedFruits(bodyA, bodyB),
        );
  }

  Fruit? _getNextSizeFruit({
    required FruitEntity fruit1,
    required FruitEntity fruit2,
  }) {
    return getNextSizeFruit(
      fruit1: fruit1.fruit.copyWith(
        pos: fruit1.body.position,
      ),
      fruit2: fruit2.fruit.copyWith(
        pos: fruit2.body.position,
      ),
    );
  }

  Fruit _getNextFruit() {
    final id = const Uuid().v4();
    final pos = Vector2(0, 0);
    final candidates = [
      FruitType.$1,
      FruitType.$2,
      FruitType.$3,
      FruitType.$4,
      FruitType.$5,
    ];
    final random = Random();
    candidates.shuffle(random);
    return Fruit(
      id: id,
      pos: pos,
      radius: candidates[0].radius,
      color: candidates[0].color,
      image: candidates[0].image,
    );
  }
}
