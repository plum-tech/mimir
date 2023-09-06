import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/course.dart';
import '../entity/entity.dart';

class _K {
  static const timetableIds = "/timetableIds";
  static const lastTimetableId = "/lastTimetableId";
  static const usedTimetableId = "/usedTimetableId";
  static const lastDisplayMode = "/lastDisplayMode";

  // TODO: Remove this and add a new personalization system.
  static const useOldSchoolPalette = "/useOldSchoolPalette";
  static const useNewUI = "/useNewUI";

  static String makeTimetableKey(String id) => "/timetables/$id";
}

class CurrentTimetableNotifier with ChangeNotifier {
  void notifier() => notifyListeners();
}

class TimetableStorage {
  final Box<dynamic> box;

  final onCurrentTimetableChanged = CurrentTimetableNotifier();

  TimetableStorage(this.box);

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.get(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.put(_K.lastDisplayMode, newValue?.index);

  int get lastTimetableId => box.get(_K.lastTimetableId) ?? 0;

  set lastTimetableId(int newValue) => box.put(_K.lastTimetableId, newValue);

  List<String> get timetableIds => box.get(_K.timetableIds) ?? <String>[];

  set timetableIds(List<String>? newValue) => box.put(_K.timetableIds, newValue);

  SitTimetable? getSitTimetableById({required String? id}) {
    if (id == null) return null;
    final table = box.get(_K.makeTimetableKey(id));
    return table == null ? null : SitTimetable.fromJson(jsonDecode(table));
  }

  void setSitTimetableById(SitTimetable? timetable, {required String id}) {
    if (timetable == null) {
      box.delete(_K.makeTimetableKey(id));
    } else {
      box.put(_K.makeTimetableKey(id), jsonEncode(timetable.toJson()));
    }
    if (id == usedTimetableId) {
      onCurrentTimetableChanged.notifier();
    }
  }

  String? get usedTimetableId => box.get(_K.usedTimetableId);

  set usedTimetableId(String? newValue) {
    box.put(_K.usedTimetableId, newValue);
    onCurrentTimetableChanged.notifier();
  }

  set useOldSchoolPalette(bool? newV) => box.put(_K.useOldSchoolPalette, newV);

  bool? get useOldSchoolPalette => box.get(_K.useOldSchoolPalette);

  set useNewUI(bool? newV) => box.put(_K.useNewUI, newV);

  bool? get useNewUI => box.get(_K.useNewUI);

  ValueListenable<Box> get onThemeChanged => box.listenable(keys: [_K.useOldSchoolPalette, _K.useNewUI]);
}

extension TimetableStorageEx on TimetableStorage {
  bool get hasAnyTimetable => timetableIds.isNotEmpty;

  /// Delete the timetable by [id].
  /// If [SitTimetable.usedTimetableId] equals to [id], it will be also cleared.
  void deleteTimetableOf(String id) {
    final ids = timetableIds;
    if (ids.remove(id)) {
      timetableIds = ids;
      if (usedTimetableId == id) {
        usedTimetableId = null;
      }
      setSitTimetableById(null, id: id);
    }
  }

  /// Return the timetable id.
  String addTimetable(SitTimetable timetable) {
    final curId = "${lastTimetableId++}";
    final ids = timetableIds;
    ids.add(curId);
    setSitTimetableById(timetable, id: curId);
    timetableIds = ids;
    return curId;
  }

  List<({String id, SitTimetable timetable})> getAllSitTimetables() {
    final ids = timetableIds;
    final res = <({String id, SitTimetable timetable})>[];
    for (final id in ids) {
      final timetable = getSitTimetableById(id: id);
      if (timetable != null) {
        res.add((id: id, timetable: timetable));
      }
    }
    return res;
  }
}
