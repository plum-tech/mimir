import 'package:flutter/material.dart';
import 'package:sit/timetable/entity/platte.dart';

import 'entity/timetable.dart';

/// https://m3.material.io/theme-builder#/custom
class BuiltinTimetablePalettes {
  static const classic = BuiltinTimetablePalette(id: -2, key: "classic", colors: [
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
  ]);
  static const oldSchool = BuiltinTimetablePalette(id: -1, key: "oldSchool", colors: [
    (light: Color(0xD2FB5352), dark: Color(0xDFF4534B)),
    (light: Color(0xD2737BFA), dark: Color(0xDF646EDC)),
    (light: Color(0xD274B9FF), dark: Color(0xDF5A87C8)),
    (light: Color(0xD2767EFD), dark: Color(0xDF586AD5)),
    (light: Color(0xD2F5AF4D), dark: Color(0xDFC87D6B)),
    (light: Color(0xD2BB896A), dark: Color(0xDF785C42)),
    (light: Color(0xD2E84393), dark: Color(0xDFB42375)),
    (light: Color(0xD2BC8CF0), dark: Color(0xDF9464B4)),
    (light: Color(0xD274B9FF), dark: Color(0xDF3855C8)),
  ]);
  static const all = [
    classic,
    oldSchool,
  ];
}

extension TimetablePlatteX on TimetablePalette {
  Color2Mode resolveColor(SitCourse course) {
    assert(colors.isNotEmpty, "Colors can't be empty");
    if (colors.isEmpty) return (light: Colors.white, dark: Colors.black);
    return colors[course.courseCode.hashCode.abs() % colors.length];
  }

  Color2Mode safeGetColor(int index) {
    assert(colors.isNotEmpty, "Colors can't be empty");
    if (colors.isEmpty) return (light: Colors.white, dark: Colors.black);
    return colors[index % colors.length];
  }
}

extension Color2ModeX on Color2Mode {
  Color byTheme(ThemeData theme) => theme.brightness == Brightness.dark ? dark : light;

  Color byBrightness(Brightness brightness) => brightness == Brightness.dark ? dark : light;
}
