import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/hive/table.dart';
import 'package:sit/timetable/entity/timetable.dart';

import '../entity/display.dart';

class _K {
  static const timetable = "/timetable";
  static const lastDisplayMode = "/lastDisplayMode";

  // TODO: add a new personalization system.
}

class TimetableStorage {
  final Box box;

  final HiveTable<SitTimetable> timetable;

  TimetableStorage(this.box)
      : timetable = HiveTable<SitTimetable>(
            base: _K.timetable,
            box: box,
            useJson: (fromJson: SitTimetable.fromJson, toJson: (timetable) => timetable.toJson()));

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.get(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.put(_K.lastDisplayMode, newValue?.index);
}
