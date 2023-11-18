import 'dart:ui';

import 'package:system_theme/system_theme.dart';
import 'package:universal_platform/universal_platform.dart';

extension ColorX on Color {
  Color monochrome({double progress = 1}) {
    final gray = 0.21 * red + 0.71 * green + 0.07 * blue;
    final iProgress = 1.0 - progress;
    return Color.fromARGB(
      alpha,
      (red * iProgress + gray * progress).toInt(),
      (green * iProgress + gray * progress).toInt(),
      (blue * iProgress + gray * progress).toInt(),
    );
  }
}

extension SystemAccentColorX on SystemAccentColor {
  Color? get maybeAccent => supportSystemAccentColor ? accent : null;
}

bool get supportSystemAccentColor =>
    UniversalPlatform.isWeb ||
    UniversalPlatform.isWindows ||
    UniversalPlatform.isMacOS ||
    UniversalPlatform.isAndroid ||
    UniversalPlatform.isLinux;
