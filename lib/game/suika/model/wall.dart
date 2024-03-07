import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';

@immutable
class Wall {
  const Wall({
    required this.pos,
    required this.size,
  });
  final Vector2 pos;
  final Vector2 size;

  static const double friction = 0.3;
  static const PaletteEntry color = BasicPalette.orange;
}
