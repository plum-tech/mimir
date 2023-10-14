import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/hive/table.dart';
import 'package:sit/timetable/entity/timetable.dart';

import '../entity/display.dart';
import '../entity/platte.dart';

class _K {
  static const timetable = "/timetable";
  static const lastDisplayMode = "/lastDisplayMode";
  static const palette = "/palette";
}

class TimetableStorage {
  final Box box;

  final HiveTable<SitTimetable> timetable;
  final HiveTable<TimetablePalette> palette;

  TimetableStorage(this.box)
      : timetable = HiveTable<SitTimetable>(
          base: _K.timetable,
          box: box,
          useJson: (fromJson: SitTimetable.fromJson, toJson: (timetable) => timetable.toJson()),
        ),
        palette = HiveTable<TimetablePalette>(
          base: _K.palette,
          box: box,
          useJson: (fromJson: TimetablePalette.fromJson, toJson: (palette) => palette.toJson()),
        );

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.get(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.put(_K.lastDisplayMode, newValue?.index);
}
