import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../domain/game_state.dart';
import '../model/game_over_line.dart';
import '../model/physics_fruit.dart';
import '../model/prediction_line.dart';
import '../model/score.dart';
import '../presenter/dialog_presenter.dart';
import '../presenter/game_over_panel_presenter.dart';
import '../presenter/next_text_presenter.dart';
import '../presenter/prediction_line_presenter.dart';
import '../presenter/score_presenter.dart';
import '../presenter/world_presenter.dart';
import '../repository/game_repository.dart';
import 'package:get_it/get_it.dart';

class NextTextComponent extends TextComponent with HasGameRef<SuikaGame> {
  NextTextComponent() : super(text: 'Next');

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(10, 15);
  }
}

final screenSize = Vector2(18, 28);
final center = Vector2(0, 9);

class SuikaGame extends Forge2DGame with TapCallbacks, MultiTouchDragDetector {
  SuikaGame() : super(gravity: Vector2(0, 69.8)) {
    assets = AssetsCache(prefix: "assets/game/suika/");
    images = Images(prefix: "assets/game/suika/");
  }


  @override
  Color backgroundColor() {
    return const PaletteEntry(Color(0xFFE4CE9D)).color;
  }

  GameState get _gameState => GetIt.I.get<GameState>();

  @override
  void update(double dt) {
    super.update(dt);
    _gameState.onUpdate();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await GetIt.I.reset();
    final predictionLineComponent = PredictionLineComponent();
    final scoreComponent = ScoreComponent();
    final nextTextComponent = NextTextComponent();

    final gameOverLine = GameOverLine(
      worldToScreen(center - Vector2(screenSize.x + 1, screenSize.y)),
      worldToScreen(center - Vector2(-screenSize.x - 1, screenSize.y)),
    );
    add(predictionLineComponent);
    add(scoreComponent);
    add(nextTextComponent);
    add(gameOverLine);

    GetIt.I.registerSingleton<GameRepository>(
      GameRepository(),
    );
    GetIt.I.registerSingleton<GameState>(
      GameState(
        worldToScreen: worldToScreen,
        screenToWorld: screenToWorld,
        camera: camera,
        add: add,
      ),
    );
    GetIt.I.registerSingleton<WorldPresenter>(
      WorldPresenter(world),
    );
    GetIt.I.registerSingleton<PredictionLinePresenter>(
      PredictionLinePresenter(predictionLineComponent),
    );
    GetIt.I.registerSingleton<ScorePresenter>(
      ScorePresenter(scoreComponent),
    );

    GetIt.I.registerSingleton<NextTextPresenter>(
      NextTextPresenter(nextTextComponent),
    );
    GetIt.I.registerSingleton<GameOverPanelPresenter>(
      GameOverPanelPresenter(),
    );
    GetIt.I.registerSingleton<DialogPresenter>(
      DialogPresenter(),
    );

    _gameState.onLoad();

    world.physicsWorld.setContactListener(
      FruitsContactListener(),
    );
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    super.onDragUpdate(pointerId, info);
    _gameState.onDragUpdate(pointerId, info.eventPosition.global);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    super.onDragEnd(pointerId, info);
    _gameState.isDragEnd = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _gameState.onTap(event.localPosition.x);
  }
}

class FruitsContactListener extends ContactListener {
  FruitsContactListener();

  @override
  void beginContact(Contact contact) {
    final bodyA = contact.fixtureA.body;
    final bodyB = contact.fixtureB.body;
    final userDataA = bodyA.userData;
    final userDataB = bodyB.userData;

    if (userDataA is PhysicsFruit && userDataB is PhysicsFruit) {
      if (userDataA.isStatic || userDataB.isStatic) {
        return;
      }
      // When balls of the same size collide
      if (userDataA.fruit.radius == userDataB.fruit.radius) {
        GetIt.I.get<GameState>().onCollidedSameSizeFruits(
              bodyA: bodyA,
              bodyB: bodyB,
            );
      }
    }
  }
}
