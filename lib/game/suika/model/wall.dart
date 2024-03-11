import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';

@immutable
class Wall {
  static const double friction = 0.8;
  static const PaletteEntry color = BasicPalette.orange;
  const Wall({
    required this.pos,
    required this.size,
  });
  final Vector2 pos;
  final Vector2 size;
}
