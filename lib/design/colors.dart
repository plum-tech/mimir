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

  ({Color bg, Color text}) makeTabHeaderTextBgColors(bool isSelected) {
    final Color text;
    final Color bg;
    if (isDarkMode) {
      if (isSelected) {
        bg = theme.secondaryHeaderColor;
      } else {
        bg = Colors.transparent;
      }
      text = Colors.white;
    } else {
      if (isSelected) {
        bg = theme.primaryColor;
        text = Colors.white;
      } else {
        bg = Colors.transparent;
        text = Colors.black;
      }
    }
    return (text: text, bg: bg);
  }
}

typedef Color2Mode = ({Color light, Color dark});

extension ColorPairHelper on Color2Mode {
  Color by(BuildContext ctx) => ctx.isDarkMode ? dark : light;

  Color byTheme(ThemeData theme) => theme.isDark ? dark : light;
}

/// https://m3.material.io/theme-builder#/custom
class CourseColor {
  static const List<Color2Mode> oldSchool = [
    (
      light: Color.fromARGB(178, 251, 83, 82),
      dark: Color.fromARGB(178, 244, 83, 75),
    ),
    (
      light: Color.fromARGB(153, 115, 123, 250),
      dark: Color.fromARGB(178, 100, 110, 220)
    ),
    (
      light: Color.fromARGB(178, 116, 185, 255),
      dark: Color.fromARGB(178, 90, 135, 200)
    ),
    (
      light: Color.fromARGB(178, 118, 126, 253),
      dark: Color.fromARGB(178, 88, 106, 213)
    ),
    (
      light: Color.fromARGB(178, 245, 175, 77),
      dark: Color.fromARGB(178, 200, 125, 107)
    ),
    (
      light: Color.fromARGB(178, 187, 137, 106),
      dark: Color.fromARGB(178, 120, 92, 66)
    ),
    (
      light: Color.fromARGB(178, 232, 67, 147),
      dark: Color.fromARGB(178, 180, 35, 117)
    ),
    (
      light: Color.fromARGB(178, 188, 140, 240),
      dark: Color.fromARGB(178, 148, 100, 180)
    ),
    (
      light: Color.fromARGB(178, 116, 185, 255),
      dark: Color.fromARGB(178, 56, 85, 200)
    ),
  ];
  static const List<Color2Mode> v1_5 = [
    (light: Color(0xD285e779), dark: Color(0xDF21520f)), // green #678a5c
    (light: Color(0xD2c3e8ff), dark: Color(0xDF004c68)), // sky #5487a3
    (light: Color(0xD2ffa6bb), dark: Color(0xDF8e2f56)), // pink #ae6f83
    (light: Color(0xD2ad9bd7), dark: Color(0xDF50378a)), // violet #8879ab
    (light: Color(0xD2ff9d6b), dark: Color(0xDF7f2b00)), // orange #a23900
    (light: Color(0xD2ffa2d2), dark: Color(0xDF8e0032)), // rose #b50060
    (light: Color(0xD2ffd200), dark: Color(0xDF523900)), // lemon #b09e40
    (light: Color(0xD275f8e2), dark: Color(0xDF005047)), // cyan #008f7f
    (light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // ice #b3c7cf
    (light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // cyan #d4bdce
    (light: Color(0xD2ffd7f5), dark: Color(0xDF7c157a)), // mauve #ff8df3
    (light: Color(0xD2eaf141), dark: Color(0xDF4b4c00)), // toxic #a2c300
  ];

  static get({required ThemeData from, required int by}) =>
      oldSchool[by.abs() % oldSchool.length].byTheme(from);
}

const electricityColor = (light: Color(0xFFffd200), dark: Color(0xFFfffc00));

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
