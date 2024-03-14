import 'package:flutter/material.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/utils/color.dart';

import 'entity/timetable.dart';

/// https://m3.material.io/theme-builder#/custom
class BuiltinTimetablePalettes {
  static const classic = BuiltinTimetablePalette(
    id: -1,
    key: "classic",
    author: "Li_plum@outlook.com",
    colors: [
      (light: Color(0xD285e779), dark: Color(0xDF21520f)), // green
      (light: Color(0xD2c3e8ff), dark: Color(0xDF004c68)), // sky
      (light: Color(0xD2ffa6bb), dark: Color(0xDF8e2f56)), // pink
      (light: Color(0xD2ad9bd7), dark: Color(0xDF50378a)), // violet
      (light: Color(0xD2ff9d6b), dark: Color(0xDF7f2b00)), // orange
      (light: Color(0xD2ffa2d2), dark: Color(0xDF8e0032)), // rose
      (light: Color(0xD2ffd200), dark: Color(0xDF523900)), // lemon
      (light: Color(0xD275f8e2), dark: Color(0xDF005047)), // cyan
      (light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // ice
      (light: Color(0xD2ffd7f5), dark: Color(0xDF7c157a)), // mauve
      (light: Color(0xD2eaf141), dark: Color(0xDF4b4c00)), // toxic
    ],
  );
  static const americano = BuiltinTimetablePalette(
    id: -2,
    key: "americano",
    author: "Gracie",
    colors: [
      (dark: Color(0xff4d5a3f), light: Color(0xe67a8d62)),
      (dark: Color(0xff837a69), light: Color(0xffedddbe)),
      (dark: Color(0xff6a3634), light: Color(0xe6c86563)),
      (dark: Color(0xff98814c), light: Color(0xffe7c574)),
      (dark: Color(0xff14506a), light: Color(0xe60080ad)),
    ],
  );
  static const candy = BuiltinTimetablePalette(
    id: -3,
    key: "candy",
    author: "Gracie",
    colors: [
      (dark: Color(0xff877878), light: Color(0xfff1dada)),
      (dark: Color(0xff668076), light: Color(0xffb9e8d7)),
      (dark: Color(0xff6e7760), light: Color(0xffc9d8af)),
      (dark: Color(0xffa36665), light: Color(0xfff2a09e)),
      (dark: Color(0xff676f7f), light: Color(0xffbbc9e6)),
      (dark: Color(0xff786e7a), light: Color(0xffdac8dd)),
      (dark: Color(0xff87786e), light: Color(0xfff2d8c8)),
    ],
  );
  static const spring = BuiltinTimetablePalette(
    id: -4,
    key: "sprint",
    author: "Gracie",
    colors: [
      (dark: Color(0xff6c8081), light: Color(0xffa5c2c4)),
      (dark: Color(0xff88877c), light: Color(0xfff3f1e1)),
      (dark: Color(0xff715252), light: Color(0xffae7e7e)),
      (dark: Color(0xff799995), light: Color(0xffbae5df)),
      (dark: Color(0xff799279), light: Color(0xffb9dbb9)),
      (dark: Color(0xff907f6d), light: Color(0xffffe4c8)),
    ],
  );
  static const summary = BuiltinTimetablePalette(
    id: -5,
    key: "summary",
    author: "Gracie",
    colors: [
      (dark: Color(0xffaca88b), light: Color(0xfffffad3)),
      (dark: Color(0xff976455), light: Color(0xffe69782)),
      (dark: Color(0xff7ca07f), light: Color(0xffbeedc3)),
      (dark: Color(0xff3c5b51), light: Color(0xff5e8f7f)),
      (dark: Color(0xff93997b), light: Color(0xffdce4bd)),
      (dark: Color(0xffa78044), light: Color(0xffffc367)),
    ],
  );
  static const fall = BuiltinTimetablePalette(
    id: -6,
    key: "fall",
    author: "Gracie",
    colors: [
      (dark: Color(0xff9e9c7e), light: Color(0xffece9c1)),
      (dark: Color(0xff977955), light: Color(0xffe6b982)),
      (dark: Color(0xff8e8471), light: Color(0xffd5c6af)),
      (dark: Color(0xff626a48), light: Color(0xff97a470)),
      (dark: Color(0xff6e5c46), light: Color(0xffaa8f6c)),
      (dark: Color(0xff96563a), light: Color(0xffe68358)),
    ],
  );
  static const winter = BuiltinTimetablePalette(
    id: -7,
    key: "winter",
    author: "Gracie",
    colors: [
      (dark: Color(0xff7c8787), light: Color(0xffc3dede)),
      (dark: Color(0xff7e7f6d), light: Color(0xffe5e6c4)),
      (dark: Color(0xff4d6067), light: Color(0xff90b2c0)),
      (dark: Color(0xff4e6f6d), light: Color(0xff8fcdca)),
      (dark: Color(0xff5e6d5e), light: Color(0xffabc8ad)),
      (dark: Color(0xff4c5253), light: Color(0xffb9c6c9)),
    ],
  );
  static const thicket = BuiltinTimetablePalette(
    id: -8,
    key: "thicket",
    author: "Gracie",
    colors: [
      (dark: Color(0xff506952), light: Color(0xff7da37f)),
      (dark: Color(0xff547b65), light: Color(0xff81bc95)),
      (dark: Color(0xff465753), light: Color(0xff6e8882)),
      (dark: Color(0xff7b978d), light: Color(0xffbce2d4)),
      (dark: Color(0xff9e948a), light: Color(0xffecdfd0)),
    ],
  );
  static const creeksideBreeze = BuiltinTimetablePalette(
    id: -9,
    key: "creeksideBreeze",
    author: "Gracie",
    colors: [
      (dark: Color(0xff6c8080), light: Color(0xffc4e7e7)),
      (dark: Color(0xff748e87), light: Color(0xffdcf4f1)),
      (dark: Color(0xff3e5657), light: Color(0xff77a3a5)),
      (dark: Color(0xff7c726f), light: Color(0xffbcada9)),
      (dark: Color(0xff5d5a5a), light: Color(0xfff4ecec)),
    ],
  );

  static const all = [
    classic,
    americano,
    candy,
    spring,
    summary,
    fall,
    winter,
    thicket,
    creeksideBreeze,
  ];
}

extension TimetablePlatteX on TimetablePalette {
  Color2Mode resolveColor(SitCourse course) {
    assert(colors.isNotEmpty, "Colors can't be empty");
    if (colors.isEmpty) return TimetablePalette.defaultColor;
    return colors[course.courseCode.hashCode.abs() % colors.length];
  }

  Color2Mode safeGetColor(int index) {
    assert(colors.isNotEmpty, "Colors can't be empty");
    if (colors.isEmpty) return TimetablePalette.defaultColor;
    return colors[index % colors.length];
  }
}

extension Color2ModeX on Color2Mode {
  Color byTheme(ThemeData theme) => theme.brightness == Brightness.dark ? dark : light;

  Color byBrightness(Brightness brightness) => brightness == Brightness.dark ? dark : light;
}

extension ColorX on Color {
  Color resolveTextColorByLuminance() {
    return luminance >= 0.5 ? Colors.black : Colors.white;
  }
}

