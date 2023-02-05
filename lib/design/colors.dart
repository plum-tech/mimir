import 'package:flutter/material.dart';
import 'package:mimir/design/utils.dart';
import 'package:rettulf/rettulf.dart';

Color getThemeColor(BuildContext ctx) {
  final theme = ctx.theme;
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onPrimary;
  }
}

Color getDarkSafeThemeColor(BuildContext ctx) {
  final theme = ctx.theme;
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return Color.lerp(theme.colorScheme.onPrimary, Colors.white, 0.6)!;
  }
}

Color getFgColor(BuildContext ctx) {
  final theme = ctx.theme;
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onSurface;
  }
}

Color getBgColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return Color.lerp(theme.primaryColor, Colors.white, 0.9)!;
  } else {
    return theme.colorScheme.onSecondary;
  }
}

Color getChessBoardColor(BuildContext ctx, int index) {
  if (ctx.isLightMode) {
    return index.isOdd ? Colors.white : Colors.black12;
  } else {
    return index.isOdd ? Colors.black38 : Colors.white12;
  }
}

extension DesignExtension on BuildContext {
  Color get themeColor => getThemeColor(this);

  Color get darkSafeThemeColor => getDarkSafeThemeColor(this);

  Color get fgColor => getFgColor(this);

  Color get bgColor => getBgColor(this);

  Color chessBoardColor({required int at}) => getChessBoardColor(this, at);

  Color get textColor => isDarkMode ? Colors.white70 : Colors.black;

  Color get reversedTextColor => isDarkMode ? Colors.black : Colors.white70;

  ColorTuple makeTabHeaderTextBgColors(bool isSelected) {
    final Color textColor;
    final Color bgColor;
    if (isDarkMode) {
      if (isSelected) {
        bgColor = theme.secondaryHeaderColor;
      } else {
        bgColor = Colors.transparent;
      }
      textColor = Colors.white;
    } else {
      if (isSelected) {
        bgColor = theme.primaryColor;
        textColor = Colors.white;
      } else {
        bgColor = Colors.transparent;
        textColor = Colors.black;
      }
    }
    return ColorTuple(textColor, bgColor);
  }
}

class ColorTuple {
  final Color a;
  final Color b;

  const ColorTuple(this.a, this.b);

  factory ColorTuple.from(int a, int b) {
    return ColorTuple(Color(a), Color(b));
  }
}

class ColorPair {
  final Color light;
  final Color dark;

  const ColorPair(this.light, this.dark);

  factory ColorPair.from(int light, int dark) {
    return ColorPair(Color(light), Color(dark));
  }
}

extension ColorPairHelper on ColorPair {
  Color by(BuildContext ctx) => ctx.isDarkMode ? dark : light;

  Color byTheme(ThemeData theme) => theme.isDark ? dark : light;
}

typedef _Cp = ColorPair;

/// https://m3.material.io/theme-builder#/custom
class CourseColor {
  static const List<ColorPair> oldSchool = [
    _Cp(Color.fromARGB(178, 251, 83, 82), Color.fromARGB(178, 244, 83, 75)),
    _Cp(Color.fromARGB(153, 115, 123, 250), Color.fromARGB(178, 100, 110, 220)),
    _Cp(Color.fromARGB(178, 116, 185, 255), Color.fromARGB(178, 90, 135, 200)),
    _Cp(Color.fromARGB(178, 118, 126, 253), Color.fromARGB(178, 88, 106, 213)),
    _Cp(Color.fromARGB(178, 245, 175, 77), Color.fromARGB(178, 200, 125, 107)),
    _Cp(Color.fromARGB(178, 187, 137, 106), Color.fromARGB(178, 120, 92, 66)),
    _Cp(Color.fromARGB(178, 232, 67, 147), Color.fromARGB(178, 180, 35, 117)),
    _Cp(Color.fromARGB(178, 188, 140, 240), Color.fromARGB(178, 148, 100, 180)),
    _Cp(Color.fromARGB(178, 116, 185, 255), Color.fromARGB(178, 56, 85, 200)),
  ];
  static const List<ColorPair> v1_5 = [
    _Cp(Color(0xD285e779), Color(0xDF21520f)), // green #678a5c
    _Cp(Color(0xD2c3e8ff), Color(0xDF004c68)), // sky #5487a3
    _Cp(Color(0xD2ffa6bb), Color(0xDF8e2f56)), // pink #ae6f83
    _Cp(Color(0xD2ad9bd7), Color(0xDF50378a)), // violet #8879ab
    _Cp(Color(0xD2ff9d6b), Color(0xDF7f2b00)), // orange #a23900
    _Cp(Color(0xD2ffa2d2), Color(0xDF8e0032)), // rose #b50060
    _Cp(Color(0xD2ffd200), Color(0xDF523900)), // lemon #b09e40
    _Cp(Color(0xD275f8e2), Color(0xDF005047)), // cyan #008f7f
    _Cp(Color(0xD2b4ebff), Color(0xDF004e5f)), // ice #b3c7cf
    _Cp(Color(0xD2b4ebff), Color(0xDF004e5f)), // cyan #d4bdce
    _Cp(Color(0xD2ffd7f5), Color(0xDF7c157a)), // mauve #ff8df3
    _Cp(Color(0xD2eaf141), Color(0xDF4b4c00)), // toxic #a2c300
  ];

  static get({required ThemeData from, required int by}) => oldSchool[by.abs() % oldSchool.length].byTheme(from);
}

const electricityColor = ColorPair(Color(0xFFffd200), Color(0xFFfffc00));

const List<Color> applicationColors = <Color>[
  Colors.orangeAccent,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.grey,
  Colors.green,
  Colors.yellowAccent,
  Colors.cyan,
  Colors.purple,
  Colors.teal,
];

class IconPair {
  final IconData icon;
  final Color color;

  const IconPair(this.icon, this.color);
}
