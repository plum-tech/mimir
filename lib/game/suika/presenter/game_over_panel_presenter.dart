import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import '../domain/game_state.dart';
import '../presenter/world_presenter.dart';
import 'package:get_it/get_it.dart';

class GameOverPanel extends PositionComponent with TapCallbacks {
  GameOverPanel()
      : _textPaint = TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 4,
          ),
        ),
        _buttonPaint = Paint()..color = Colors.blue {
    size = Vector2(30, 20);
    anchor = Anchor.center;
    position = Vector2(0, 0);
  }
  final TextPaint _textPaint;
  late Rect _retryButtonRect;
  final Paint _buttonPaint;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawBackground(canvas);
    _drawGameOverText(canvas);
    _drawRetryButton(canvas);
  }

  void _drawBackground(Canvas canvas) {
    final rect = size.toRect();
    canvas.drawRect(rect, Paint()..color = Colors.grey.withOpacity(0.85));
  }

  void _drawGameOverText(Canvas canvas) {
    _textPaint.render(canvas, 'Game Over', Vector2(5, 4));
  }

  void _drawRetryButton(Canvas canvas) {
    _retryButtonRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y - 5),
      width: 20,
      height: 5,
    );
    canvas.drawRect(_retryButtonRect, _buttonPaint);
    _textPaint.render(canvas, 'Retry', Vector2(size.x / 2 - 5, size.y - 7.5));
  }

  @override
  bool containsPoint(Vector2 point) {
    return _retryButtonRect.contains(point.toOffset());
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    GetIt.I.get<GameState>().reset();
  }
}

class GameOverPanelPresenter {
  WorldPresenter get _worldPresenter => GetIt.I.get<WorldPresenter>();
  void show() {
    _worldPresenter.add(GameOverPanel());
  }
}
