import 'package:flutter/material.dart';
import 'package:sit/timetable/entity/platte.dart';

import 'entity/timetable.dart';

/// https://m3.material.io/theme-builder#/custom
class BuiltinTimetablePalettes {
  static const oldSchool = BuiltinTimetablePalette(id: "old school", colors: [
    Color2Mode(light: Color(0xB2FB5352), dark: Color(0xB2F4534B)),
    Color2Mode(light: Color(0x99737BFA), dark: Color(0xB2646EDC)),
    Color2Mode(light: Color(0xB274B9FF), dark: Color(0xB25A87C8)),
    Color2Mode(light: Color(0xB2767EFD), dark: Color(0xB2586AD5)),
    Color2Mode(light: Color(0xB2F5AF4D), dark: Color(0xB2C87D6B)),
    Color2Mode(light: Color(0xB2BB896A), dark: Color(0xB2785C42)),
    Color2Mode(light: Color(0xB2E84393), dark: Color(0xB2B42375)),
    Color2Mode(light: Color(0xB2BC8CF0), dark: Color(0xB29464B4)),
    Color2Mode(light: Color(0xB274B9FF), dark: Color(0xB23855C8)),
  ]);

  static const newUI = BuiltinTimetablePalette(id: "new ui", colors: [
    Color2Mode(light: Color(0xD285e779), dark: Color(0xDF21520f)), // green
    Color2Mode(light: Color(0xD2c3e8ff), dark: Color(0xDF004c68)), // sky
    Color2Mode(light: Color(0xD2ffa6bb), dark: Color(0xDF8e2f56)), // pink
    Color2Mode(light: Color(0xD2ad9bd7), dark: Color(0xDF50378a)), // violet
    Color2Mode(light: Color(0xD2ff9d6b), dark: Color(0xDF7f2b00)), // orange
    Color2Mode(light: Color(0xD2ffa2d2), dark: Color(0xDF8e0032)), // rose
    Color2Mode(light: Color(0xD2ffd200), dark: Color(0xDF523900)), // lemon
    Color2Mode(light: Color(0xD275f8e2), dark: Color(0xDF005047)), // cyan
    Color2Mode(light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // ice
    Color2Mode(light: Color(0xD2b4ebff), dark: Color(0xDF004e5f)), // cyan
    Color2Mode(light: Color(0xD2ffd7f5), dark: Color(0xDF7c157a)), // mauve
    Color2Mode(light: Color(0xD2eaf141), dark: Color(0xDF4b4c00)), // toxic
  ]);
}

extension TimetablePlatteX on ITimetablePalette {
  Color2Mode resolveColor(SitCourse course) {
    return colors[course.courseCode.hashCode.abs() % colors.length];
  }
}

extension Color2ModeX on Color2Mode {
  Color byTheme(ThemeData theme) => theme.brightness == Brightness.dark ? dark : light;
}
