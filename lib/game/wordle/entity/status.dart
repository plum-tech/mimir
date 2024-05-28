import 'package:flutter/material.dart';
import 'package:sit/design/entity/color2mode.dart';

enum LetterStatus {
  /// 0
  neutral(
    bg: (light: Colors.white, dark: Color(0xFF303030)),
    border: Color(0xFF616161),
    inverseText: false,
  ),

  /// 1
  correct(
    bg: (light: Color(0xFF43A047), dark: Color(0xFF43A047)),
    border: Color(0xFF43A047),
  ),

  /// 2
  dislocated(
    bg: (light: Color(0xFFF9A825), dark: Color(0xFFF9A825)),
    border: Color(0xFFF9A825),
  ),

  /// -1
  wrong(
    bg: (light: Color(0xFF616161), dark: Color(0xFF616161)),
    border: Color(0xFF616161),
  );

  final Color2Mode bg;
  final Color border;
  final bool inverseText;

  const LetterStatus({
    required this.bg,
    required this.border,
    this.inverseText = true,
  });
}
