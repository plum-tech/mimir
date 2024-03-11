import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class GameOverLine extends Component {
  GameOverLine(this.startPosition, this.endPosition);
  late final Vector2 startPosition;
  late final Vector2 endPosition;
  final double thickness = 5;

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.drawLine(startPosition.toOffset(), endPosition.toOffset(), paint);
  }
}
