import 'dart:ui';

enum LetterStatus {
  /// 0
  neutral(
    bg: Color(0xFF303030),
    border: Color(0xFF616161),
  ),

  /// 1
  correct(
    bg: Color(0xFF43A047),
    border: Color(0xFF43A047),
  ),

  /// 2
  dislocated(
    bg: Color(0xFFF9A825),
    border: Color(0xFFF9A825),
  ),

  /// -1
  wrong(
    bg: Color(0xFF616161),
    border: Color(0xFF616161),
  );

  final Color bg;
  final Color border;

  const LetterStatus({
    required this.bg,
    required this.border,
  });
}
