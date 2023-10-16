import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _kAutoUseImported = true;
const _kShowTeachers = true;

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
}

class _Cell {
  final Box box;

  const _Cell(this.box);

  bool get showTeachers => box.get(_CellK.showTeachers) ?? _kShowTeachers;

  set showTeachers(bool newV) => box.put(_CellK.showTeachers, newV);

  ValueListenable listenStyle() => box.listenable(keys: [_CellK.showTeachers]);
}
