import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/style.dart';

const _kAutoUseImported = true;
const _kShowTeachers = true;
const _kGrayOutTakenLessons = false;
const _kHarmonizeWithThemeColor = true;
const _kAlpha = 1.0;

class _K {
  static const ns = "/timetable";
  static const autoUseImported = "$ns/autoUseImported";
}

class TimetableSettings {
  final Box box;

  TimetableSettings(this.box);

  late final cell = _Cell(box);

  bool get autoUseImported => box.get(_K.autoUseImported) ?? _kAutoUseImported;

  set autoUseImported(bool newV) => box.put(_K.autoUseImported, newV);
}

class _CellK {
  static const ns = "${_K.ns}/cell";
  static const showTeachers = "$ns/showTeachers";
  static const grayOutTakenLessons = "$ns/grayOutTakenLessons";
  static const harmonizeWithThemeColor = "$ns/harmonizeWithThemeColor";
  static const alpha = "$ns/alpha";
}

class _Cell {
  final Box box;

  const _Cell(this.box);

  bool get showTeachers => box.get(_CellK.showTeachers) ?? _kShowTeachers;

  set showTeachers(bool newV) => box.put(_CellK.showTeachers, newV);

  bool get grayOutTakenLessons => box.get(_CellK.grayOutTakenLessons) ?? _kGrayOutTakenLessons;

  set grayOutTakenLessons(bool newV) => box.put(_CellK.grayOutTakenLessons, newV);

  bool get harmonizeWithThemeColor => box.get(_CellK.harmonizeWithThemeColor) ?? _kHarmonizeWithThemeColor;

  set harmonizeWithThemeColor(bool newV) => box.put(_CellK.harmonizeWithThemeColor, newV);

  double get alpha => box.get(_CellK.alpha) ?? _kAlpha;

  set alpha(double newV) => box.put(_CellK.alpha, newV);

  ValueListenable listenStyle() => box.listenable(keys: [
        _CellK.showTeachers,
        _CellK.grayOutTakenLessons,
        _CellK.harmonizeWithThemeColor,
        _CellK.alpha,
      ]);

  CourseCellStyle get cellStyle => CourseCellStyle(
        showTeachers: showTeachers,
        grayOutTakenLessons: grayOutTakenLessons,
        harmonizeWithThemeColor: harmonizeWithThemeColor,
        alpha: alpha,
      );

  set cellStyle(CourseCellStyle newV) {
    showTeachers = newV.showTeachers;
    grayOutTakenLessons = newV.grayOutTakenLessons;
    harmonizeWithThemeColor = newV.harmonizeWithThemeColor;
    alpha = newV.alpha;
  }
}
