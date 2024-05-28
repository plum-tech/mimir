import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';

class ColorEntry {
  final Color color;
  final bool inverseText;

  const ColorEntry(
    this.color, {
    this.inverseText = false,
  });

  const ColorEntry.inverse(
    this.color,
  ) : inverseText = true;
}

class DualColor {
  final ColorEntry light;
  final ColorEntry dark;

  const DualColor({
    required this.light,
    required this.dark,
  });
}

extension ColorEntryX on ColorEntry {
  Color textColor(BuildContext context) =>
      inverseText ? context.colorScheme.onInverseSurface : context.colorScheme.onSurface;
}

extension DualColorX on DualColor {
  ColorEntry byBrightness(Brightness brightness) => brightness == Brightness.dark ? dark : light;

  ColorEntry byContext(BuildContext context) => context.isDarkMode ? dark : light;

  Color colorBy(BuildContext context) => (context.isDarkMode ? dark : light).color;

  Color textColorBy(BuildContext context) => (context.isDarkMode ? dark : light).textColor(context);
}
