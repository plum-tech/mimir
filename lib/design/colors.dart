import 'package:flutter/material.dart';
import 'package:mimir/design/utils.dart';
import 'package:rettulf/rettulf.dart';

extension DesignExtension on BuildContext {
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

extension Color2ModeX on Color2Mode {
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
  static const List<Color2Mode> newUI = [
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
