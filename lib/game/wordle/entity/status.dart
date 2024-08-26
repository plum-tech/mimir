import 'package:flutter/material.dart';
import 'package:mimir/design/entity/dual_color.dart';

enum LetterStatus {
  /// 0
  neutral(
    bg: DualColor(
      light: ColorEntry(Colors.white),
      dark: ColorEntry(Color(0xFF303030)),
    ),
    border: Color(0xFF616161),
  ),

  /// 1
  correct(
    bg: DualColor(
      light: ColorEntry.inverse(Color(0xFF43A047)),
      dark: ColorEntry(Color(0xFF43A047)),
    ),
    border: Color(0xFF43A047),
  ),

  /// 2
  dislocated(
    bg: DualColor(
      light: ColorEntry.inverse(Color(0xFFF9A825)),
      dark: ColorEntry(Color(0xFFF9A825)),
    ),
    border: Color(0xFFF9A825),
  ),

  /// -1
  wrong(
    bg: DualColor(
      light: ColorEntry.inverse(Color(0xFF616161)),
      dark: ColorEntry(Color(0xFF616161)),
    ),
    border: Color(0xFF616161),
  );

  final DualColor bg;
  final Color border;

  const LetterStatus({
    required this.bg,
    required this.border,
  });
}
