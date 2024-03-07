import 'package:flame/game.dart';
import '../model/prediction_line.dart';

class PredictionLinePresenter {
  PredictionLinePresenter(this._predictionLineComponent);
  final PredictionLineComponent _predictionLineComponent;

  /// Update the prediction line.
  void updateLine(Vector2? newStart, Vector2? newEnd) {
    _predictionLineComponent.updateLine(newStart, newEnd);
  }
}
