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
      DualColor(dark: ColorEntry(Color(0xFF4D5A3F)), light: ColorEntry.inverse(Color(0xE67A8D62))),
      DualColor(dark: ColorEntry(Color(0xFF837A69)), light: ColorEntry(Color(0xFFEDDDBE))),
      DualColor(dark: ColorEntry(Color(0xFF6A3634)), light: ColorEntry.inverse(Color(0xE6C86563))),
      DualColor(dark: ColorEntry(Color(0xFF98814C)), light: ColorEntry(Color(0xFFE7C574))),
      DualColor(dark: ColorEntry(Color(0xFF14506A)), light: ColorEntry.inverse(Color(0xE60080AD))),
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
      DualColor(dark: ColorEntry(Color(0xFF6C8081)), light: ColorEntry(Color(0xFFA5C2C4))),
      DualColor(dark: ColorEntry(Color(0xFF88877C)), light: ColorEntry(Color(0xFFF3F1E1))),
      DualColor(dark: ColorEntry(Color(0xFF715252)), light: ColorEntry.inverse(Color(0xFFAE7E7E))),
      DualColor(dark: ColorEntry(Color(0xFF799995)), light: ColorEntry(Color(0xFFBAE5DF))),
      DualColor(dark: ColorEntry(Color(0xFF799279)), light: ColorEntry(Color(0xFFB9DBB9))),
      DualColor(dark: ColorEntry(Color(0xFF907F6D)), light: ColorEntry(Color(0xFFFFE4C8))),
    ],
  );
  static const summary = BuiltinTimetablePalette(
    id: -5,
    key: "summary",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry.inverse(Color(0xFFACA88B)), light: ColorEntry(Color(0xFFFFFAD3))),
      DualColor(dark: ColorEntry(Color(0xFF976455)), light: ColorEntry(Color(0xFFE69782))),
      DualColor(dark: ColorEntry.inverse(Color(0xFF7CA07F)), light: ColorEntry(Color(0xFFBEEDC3))),
      DualColor(dark: ColorEntry(Color(0xFF3C5B51)), light: ColorEntry.inverse(Color(0xFF5E8F7F))),
      DualColor(dark: ColorEntry(Color(0xFF93997B)), light: ColorEntry(Color(0xFFDCE4BD))),
      DualColor(dark: ColorEntry(Color(0xFFA78044)), light: ColorEntry(Color(0xFFFFC367))),
    ],
  );
  static const fall = BuiltinTimetablePalette(
    id: -6,
    key: "fall",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xFF9E9C7E)), light: ColorEntry(Color(0xFFECE9C1))),
      DualColor(dark: ColorEntry(Color(0xFF977955)), light: ColorEntry(Color(0xFFE6B982))),
      DualColor(dark: ColorEntry(Color(0xFF8E8471)), light: ColorEntry(Color(0xFFD5C6AF))),
      DualColor(dark: ColorEntry(Color(0xFF626A48)), light: ColorEntry.inverse(Color(0xFF97A470))),
      DualColor(dark: ColorEntry(Color(0xFF6E5C46)), light: ColorEntry.inverse(Color(0xFFAA8F6C))),
      DualColor(dark: ColorEntry(Color(0xFF96563A)), light: ColorEntry.inverse(Color(0xFFE68358))),
    ],
  );
  static const winter = BuiltinTimetablePalette(
    id: -7,
    key: "winter",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xFF7C8787)), light: ColorEntry(Color(0xFFC3DEDE))),
      DualColor(dark: ColorEntry(Color(0xFF7E7F6D)), light: ColorEntry(Color(0xFFE5E6C4))),
      DualColor(dark: ColorEntry(Color(0xFF4D6067)), light: ColorEntry.inverse(Color(0xFF90B2C0))),
      DualColor(dark: ColorEntry(Color(0xFF4E6F6D)), light: ColorEntry(Color(0xFF8FCDCA))),
      DualColor(dark: ColorEntry(Color(0xFF5E6D5E)), light: ColorEntry(Color(0xFFABC8AD))),
      DualColor(dark: ColorEntry(Color(0xFF4C5253)), light: ColorEntry(Color(0xFFB9C6C9))),
    ],
  );
  static const thicket = BuiltinTimetablePalette(
    id: -8,
    key: "thicket",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xFF506952)), light: ColorEntry.inverse(Color(0xFF7DA37F))),
      DualColor(dark: ColorEntry(Color(0xFF547B65)), light: ColorEntry.inverse(Color(0xFF81BC95))),
      DualColor(dark: ColorEntry(Color(0xFF465753)), light: ColorEntry.inverse(Color(0xFF6E8882))),
      DualColor(dark: ColorEntry(Color(0xFF7B978D)), light: ColorEntry(Color(0xFFBCE2D4))),
      DualColor(dark: ColorEntry(Color(0xFF9E948A)), light: ColorEntry(Color(0xFFECDFD0))),
    ],
  );
  static const creeksideBreeze = BuiltinTimetablePalette(
    id: -9,
    key: "creeksideBreeze",
    author: "Gracie",
    colors: [
      DualColor(dark: ColorEntry(Color(0xFF6C8080)), light: ColorEntry(Color(0xFFC4E7E7))),
      DualColor(dark: ColorEntry(Color(0xFF748E87)), light: ColorEntry(Color(0xFFDCF4F1))),
      DualColor(dark: ColorEntry(Color(0xFF3E5657)), light: ColorEntry.inverse(Color(0xFF77A3A5))),
      DualColor(dark: ColorEntry(Color(0xFF7C726F)), light: ColorEntry(Color(0xFFBCADA9))),
      DualColor(dark: ColorEntry(Color(0xFF5D5A5A)), light: ColorEntry(Color(0xFFF4ECEC))),
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
