import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:system_theme/system_theme.dart';

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

  double get luminance => (0.2126 * red + 0.7152 * green + 0.0722 * blue) / 255.0;

  double get brightness => (0.299 * red + 0.587 * green + 0.114 * blue) / 255.0;
}

extension SystemAccentColorX on SystemAccentColor {
  Color? get maybeAccent => supportsSystemAccentColor ? accent : null;
}

bool get supportsSystemAccentColor => defaultTargetPlatform.supportsAccentColor;

class APCA {
  static double contrast(Color textColor, Color bgColor) {
    // Convert colors to Lab color space
    final labText = _rgbToLab(textColor);
    final labBg = _rgbToLab(bgColor);

    // Calculate contrast using APCA algorithm
    final contrast = _apcaContrast(labText, labBg);

    return contrast;
  }

  static List<double> _rgbToLab(Color color) {
    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;

    // RGB to XYZ
    r = _linearize(r);
    g = _linearize(g);
    b = _linearize(b);

    final x = 0.4124564 * r + 0.3575761 * g + 0.1804375 * b;
    final y = 0.2126729 * r + 0.7151522 * g + 0.0721750 * b;
    final z = 0.0193339 * r + 0.1191920 * g + 0.9503041 * b;

    // XYZ to Lab
    const xRef = 0.95047;
    const yRef = 1.0;
    const zRef = 1.08883;

    return [
      116 * _f(y / yRef) - 16, // l
      500 * (_f(x / xRef) - _f(y / yRef)), //a
      200 * (_f(y / yRef) - _f(z / zRef)), //b
    ];
  }

  static double _linearize(double channel) {
    if (channel <= 0.04045) {
      return channel / 12.92;
    } else {
      return pow((channel + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  static double _f(double t) {
    const delta = 6 / 29;
    if (t > delta * delta * delta) {
      return pow(t, 1 / 3).toDouble();
    } else {
      return (t / (3 * delta * delta)) + (4 / 29);
    }
  }

  static double _apcaContrast(List<double> labText, List<double> labBg) {
    final textL = labText[0];
    final bgL = labBg[0];

    final apca = sqrt(pow(textL, 2) - pow(bgL, 2));

    return apca;
  }
}
