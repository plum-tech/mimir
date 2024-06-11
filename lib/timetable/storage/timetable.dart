import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/storage/hive/table.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/timetable/entity/timetable.dart';

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

  final HiveTable<SitTimetable> timetable;
  final HiveTable<TimetablePalette> palette;

  TimetableStorage()
      : timetable = HiveTable<SitTimetable>(
          base: _K.timetable,
          box: HiveInit.timetable,
          useJson: (fromJson: SitTimetable.fromJson, toJson: (timetable) => timetable.toJson()),
        ),
        palette = HiveTable<TimetablePalette>(
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

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.safeGet(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.safePut(_K.lastDisplayMode, newValue?.index);
}
