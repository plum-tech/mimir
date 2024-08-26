import 'package:flutter/material.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/timetable/p13n/entity/palette.dart';

import '../entity/timetable.dart';

/// https://m3.material.io/theme-builder#/custom
class BuiltinTimetablePalettes {
  static const classic = BuiltinTimetablePalette(
    id: -1,
    key: "classic",
    author: "Li_plum@outlook.com",
    colors: [
      DualColor(dark: ColorEntry(Color(0xdf356a21)), light: ColorEntry(Color(0xd2a7d99b))),
      DualColor(dark: ColorEntry(Color(0xdf00739b)), light: ColorEntry(Color(0xd2cbe3ef))),
      DualColor(dark: ColorEntry(Color(0xdf8e2f56)), light: ColorEntry(Color(0xd2ffa6bb))),
      DualColor(dark: ColorEntry(Color(0xdf50378a)), light: ColorEntry(Color(0xd2b8a4ea))),
      DualColor(dark: ColorEntry(Color(0xdfac5029)), light: ColorEntry(Color(0xd2ecab8a))),
      DualColor(dark: ColorEntry(Color(0xdf80002d)), light: ColorEntry(Color(0xd2eeb6d3))),
      DualColor(dark: ColorEntry(Color(0xdf7c5800)), light: ColorEntry(Color(0xd2eadea1))),
      DualColor(dark: ColorEntry(Color(0xdf006b5f)), light: ColorEntry(Color(0xd292c7b8))),
      DualColor(dark: ColorEntry(Color(0xdf004e5f)), light: ColorEntry(Color(0xd2aaccd8))),
      DualColor(dark: ColorEntry(Color(0xdf7c157a)), light: ColorEntry(Color(0xd2ffd7f5))),
      DualColor(dark: ColorEntry(Color(0xdf616200)), light: ColorEntry(Color(0xd2d9dc89))),
    ],
  );
  static const americano = BuiltinTimetablePalette(
    id: -2,
    key: "americano",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff4d5a3f)), light: ColorEntry(Color(0xe67a8d62))),
      DualColor(dark: ColorEntry(Color(0xff837a69)), light: ColorEntry(Color(0xffedddbe))),
      DualColor(dark: ColorEntry(Color(0xff6a3634)), light: ColorEntry(Color(0xe6c86563))),
      DualColor(dark: ColorEntry(Color(0xff98814c)), light: ColorEntry(Color(0xffe7c574))),
      DualColor(dark: ColorEntry(Color(0xff14506a)), light: ColorEntry(Color(0xe60080ad))),
    ],
  );
  static const candy = BuiltinTimetablePalette(
    id: -3,
    key: "candy",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff877878)), light: ColorEntry(Color(0xfff1dada))),
      DualColor(dark: ColorEntry(Color(0xff668076)), light: ColorEntry(Color(0xffb9e8d7))),
      DualColor(dark: ColorEntry(Color(0xff6e7760)), light: ColorEntry(Color(0xffc9d8af))),
      DualColor(dark: ColorEntry(Color(0xffa36665)), light: ColorEntry(Color(0xfff2a09e))),
      DualColor(dark: ColorEntry(Color(0xff676f7f)), light: ColorEntry(Color(0xffbbc9e6))),
      DualColor(dark: ColorEntry(Color(0xff786e7a)), light: ColorEntry(Color(0xffdac8dd))),
      DualColor(dark: ColorEntry(Color(0xff87786e)), light: ColorEntry(Color(0xfff2d8c8))),
    ],
  );
  static const spring = BuiltinTimetablePalette(
    id: -4,
    key: "sprint",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff6c8081)), light: ColorEntry(Color(0xffa5c2c4))),
      DualColor(dark: ColorEntry(Color(0xff88877c)), light: ColorEntry(Color(0xfff3f1e1))),
      DualColor(dark: ColorEntry(Color(0xff715252)), light: ColorEntry(Color(0xffae7e7e))),
      DualColor(dark: ColorEntry(Color(0xff799995)), light: ColorEntry(Color(0xffbae5df))),
      DualColor(dark: ColorEntry(Color(0xff799279)), light: ColorEntry(Color(0xffb9dbb9))),
      DualColor(dark: ColorEntry(Color(0xff907f6d)), light: ColorEntry(Color(0xffffe4c8))),
    ],
  );
  static const summary = BuiltinTimetablePalette(
    id: -5,
    key: "summary",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xffaca88b)), light: ColorEntry(Color(0xfffffad3))),
      DualColor(dark: ColorEntry(Color(0xff976455)), light: ColorEntry(Color(0xffe69782))),
      DualColor(dark: ColorEntry(Color(0xff7ca07f)), light: ColorEntry(Color(0xffbeedc3))),
      DualColor(dark: ColorEntry(Color(0xff3c5b51)), light: ColorEntry(Color(0xff5e8f7f))),
      DualColor(dark: ColorEntry(Color(0xff93997b)), light: ColorEntry(Color(0xffdce4bd))),
      DualColor(dark: ColorEntry(Color(0xffa78044)), light: ColorEntry(Color(0xffffc367))),
    ],
  );
  static const fall = BuiltinTimetablePalette(
    id: -6,
    key: "fall",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff9e9c7e)), light: ColorEntry(Color(0xffece9c1))),
      DualColor(dark: ColorEntry(Color(0xff977955)), light: ColorEntry(Color(0xffe6b982))),
      DualColor(dark: ColorEntry(Color(0xff8e8471)), light: ColorEntry(Color(0xffd5c6af))),
      DualColor(dark: ColorEntry(Color(0xff626a48)), light: ColorEntry(Color(0xff97a470))),
      DualColor(dark: ColorEntry(Color(0xff6e5c46)), light: ColorEntry(Color(0xffaa8f6c))),
      DualColor(dark: ColorEntry(Color(0xff96563a)), light: ColorEntry(Color(0xffe68358))),
    ],
  );
  static const winter = BuiltinTimetablePalette(
    id: -7,
    key: "winter",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff7c8787)), light: ColorEntry(Color(0xffc3dede))),
      DualColor(dark: ColorEntry(Color(0xff7e7f6d)), light: ColorEntry(Color(0xffe5e6c4))),
      DualColor(dark: ColorEntry(Color(0xff4d6067)), light: ColorEntry(Color(0xff90b2c0))),
      DualColor(dark: ColorEntry(Color(0xff4e6f6d)), light: ColorEntry(Color(0xff8fcdca))),
      DualColor(dark: ColorEntry(Color(0xff5e6d5e)), light: ColorEntry(Color(0xffabc8ad))),
      DualColor(dark: ColorEntry(Color(0xff4c5253)), light: ColorEntry(Color(0xffb9c6c9))),
    ],
  );
  static const thicket = BuiltinTimetablePalette(
    id: -8,
    key: "thicket",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff506952)), light: ColorEntry(Color(0xff7da37f))),
      DualColor(dark: ColorEntry(Color(0xff547b65)), light: ColorEntry(Color(0xff81bc95))),
      DualColor(dark: ColorEntry(Color(0xff465753)), light: ColorEntry(Color(0xff6e8882))),
      DualColor(dark: ColorEntry(Color(0xff7b978d)), light: ColorEntry(Color(0xffbce2d4))),
      DualColor(dark: ColorEntry(Color(0xff9e948a)), light: ColorEntry(Color(0xffecdfd0))),
    ],
  );
  static const creeksideBreeze = BuiltinTimetablePalette(
    id: -9,
    key: "creeksideBreeze",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xff6c8080)), light: ColorEntry(Color(0xffc4e7e7))),
      DualColor(dark: ColorEntry(Color(0xff748e87)), light: ColorEntry(Color(0xffdcf4f1))),
      DualColor(dark: ColorEntry(Color(0xff3e5657)), light: ColorEntry(Color(0xff77a3a5))),
      DualColor(dark: ColorEntry(Color(0xff7c726f)), light: ColorEntry(Color(0xffbcada9))),
      DualColor(dark: ColorEntry(Color(0xff5d5a5a)), light: ColorEntry(Color(0xfff4ecec))),
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
  DualColor resolveColor(SitCourse course) {
    assert(colors.isNotEmpty, "Colors can't be empty");
    if (colors.isEmpty) return TimetablePalette.defaultColor;
    return colors[course.courseCode.hashCode.abs() % colors.length];
  }

  DualColor safeGetColor(int index) {
    assert(colors.isNotEmpty, "Colors can't be empty");
    if (colors.isEmpty) return TimetablePalette.defaultColor;
    return colors[index % colors.length];
  }
}
