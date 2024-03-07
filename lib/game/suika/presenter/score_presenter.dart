import 'package:flame/game.dart';
import '../model/score.dart';

class ScorePresenter {
  ScorePresenter(this._scoreComponent);
  int _score = 0;
  final ScoreComponent _scoreComponent;

  void addScore(int score) {
    _score += score;
    _scoreComponent.updateScore(_score);
  }

  set position(Vector2 position) {
    _scoreComponent.position = position;
  }

  int get score => _score;

  void reset() {
    _score = 0;
    _scoreComponent.updateScore(_score);
  }

  Vector2 get position => _scoreComponent.position;
}
