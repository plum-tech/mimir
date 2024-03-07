import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class PredictionLineComponent extends Component {
  Vector2? start;
  Vector2? end;

  @override
  void render(Canvas canvas) {
    if (start != null && end != null) {
      final paint = Paint()
        ..color = Colors.white70
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(start!.toOffset(), end!.toOffset(), paint);
    }
  }

  void updateLine(Vector2? newStart, Vector2? newEnd) {
    start = newStart;
    end = newEnd;
  }
}
