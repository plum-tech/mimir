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
    (light: Color(0xB2FB5352), dark: Color(0xB2F4534B)),
    (light: Color(0x99737BFA), dark: Color(0xB2646EDC)),
    (light: Color(0xB274B9FF), dark: Color(0xB25A87C8)),
    (light: Color(0xB2767EFD), dark: Color(0xB2586AD5)),
    (light: Color(0xB2F5AF4D), dark: Color(0xB2C87D6B)),
    (light: Color(0xB2BB896A), dark: Color(0xB2785C42)),
    (light: Color(0xB2E84393), dark: Color(0xB2B42375)),
    (light: Color(0xB2BC8CF0), dark: Color(0xB29464B4)),
    (light: Color(0xB274B9FF), dark: Color(0xB23855C8)),
  ];
  static const List<Color2Mode> v1_5 = [
    (light: Color(0xD285e779), dark: Color(0xDF21520f)), // green
    (light: Color(0xD2c3e8ff), dark: Color(0xDF004c68)), // sky
    (light: Color(0xD2ffa6bb), dark: Color(0xDF8e2f56)), // pink
    (light: Color(0xD2ad9bd7), dark: Color(0xDF50378a)), // violet
    (light: Color(0xD2ff9d6b), dark: Color(0xDF7f2b00)), // orange
    (light: Color(0xD2ffa2d2), dark: Color(0xDF8e0032)), // rose
    (light: Color(0xD2ffd200), dark: Color(0xDF523900)), // lemon
    (light: Color(0xD275f8e2), dark: Color(0xDF005047)), // cyan
    (light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // ice
    (light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // cyan
    (light: Color(0xD2ffd7f5), dark: Color(0xDF7c157a)), // mauve
    (light: Color(0xD2eaf141), dark: Color(0xDF4b4c00)), // toxic
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
