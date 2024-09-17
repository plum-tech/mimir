import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/storage/hive/table.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/timetable/entity/timetable.dart';

import '../entity/display.dart';
import '../p13n/builtin.dart';
import '../p13n/entity/palette.dart';

class _K {
  static const timetable = "/timetable";
  static const lastDisplayMode = "/lastDisplayMode";
  static const palette = "/palette";
}

class TimetableStorage {
  Box get box => HiveInit.timetable;

  final HiveTable<int, Timetable> timetable = HiveTable.incremental<Timetable>(
    base: _K.timetable,
    box: HiveInit.timetable,
    useJson: (fromJson: Timetable.fromJson, toJson: (timetable) => timetable.toJson()),
  );

  final HiveTable<int, TimetablePalette> palette = HiveTable.incremental<TimetablePalette>(
    base: _K.palette,
    box: HiveInit.timetable,
    useJson: (fromJson: TimetablePalette.fromJson, toJson: (palette) => palette.toJson()),
    getDelegate: (id, builtin) {
      // intercept builtin timetable
      for (final timetable in BuiltinTimetablePalettes.all) {
        if (timetable.id == id) return timetable;
      }
      return builtin(id);
    },
    setDelegate: (id, newV, builtin) {
      // skip builtin timetable
      for (final timetable in BuiltinTimetablePalettes.all) {
        if (timetable.id == id) return;
      }
      builtin(id, newV);
    },
  );

  TimetableStorage();

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.safeGet(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.safePut(_K.lastDisplayMode, newValue?.index);
}
