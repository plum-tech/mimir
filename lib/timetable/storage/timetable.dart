import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/hive/table.dart';
import 'package:mimir/timetable/entity/timetable.dart';

import '../entity/display.dart';

class _K {
  static const timetable = "/timetable";
  static const lastDisplayMode = "/lastDisplayMode";

  // TODO: Remove this and add a new personalization system.
  static const useNewUI = "/useNewUI";
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

  set useNewUI(bool? newV) => box.put(_K.useNewUI, newV);

  bool? get useNewUI => box.get(_K.useNewUI);

  ValueListenable<Box> listenUseNewUI() => box.listenable(keys: [_K.useNewUI]);

  ValueListenable<Box> get onThemeChanged => box.listenable(keys: [_K.useNewUI]);
}
