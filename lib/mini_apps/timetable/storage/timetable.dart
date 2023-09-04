import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mimir/hive/using.dart';
import 'package:mimir/mini_apps/symbol.dart';

import '../entity/course.dart';
import '../entity/entity.dart';
import '../using.dart';

class _K {
  static const timetablesNs = "/timetables";
  static const timetableIds = "/timetableIds";
  static const currentTimetableId = "/currentTimetableId";
  static const lastDisplayMode = "/lastDisplayMode";

  // TODO: Remove this and add a new personalization system.
  static const useOldSchoolPalette = "/useOldSchoolPalette";
  static const useNewUI = "/useNewUI";

  static String makeTimetableKey(String id) => "$timetablesNs/$id";
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
    if (id == currentTimetableId) {
      onCurrentTimetableChanged.notifier();
    }
  }

  String? get currentTimetableId => box.get(_K.currentTimetableId);

  set currentTimetableId(String? newValue) {
    box.put(_K.currentTimetableId, newValue);
    onCurrentTimetableChanged.notifier();
  }

  set useOldSchoolColors(bool? newV) => box.put(_K.useOldSchoolPalette, newV);

  bool? get useOldSchoolColors => box.get(_K.useOldSchoolPalette);

  set useNewUI(bool? newV) => box.put(_K.useNewUI, newV);

  bool? get useNewUI => box.get(_K.useNewUI);
}

extension TimetableStorageEx on TimetableStorage {
  bool get hasAnyTimetable => timetableIds.isNotEmpty;

  /// Delete the timetable by [id].
  /// If [SitTimetable.currentTimetableId] equals to [id], it will be also cleared.
  void deleteTimetableOf(String id) {
    final ids = timetableIds;
    if (ids.remove(id)) {
      timetableIds = ids;
      if (currentTimetableId == id) {
        currentTimetableId = null;
      }
      setSitTimetableById(null, id: id);
    }
  }

  void addTimetable(SitTimetable timetable) {
    final id = timetable.id;
    final ids = timetableIds;
    ids.add(id);
    setSitTimetableById(timetable, id: id);
    timetableIds = ids;
  }

  List<SitTimetable> getAllSitTimetables() {
    final ids = timetableIds;
    final res = <SitTimetable>[];
    for (final id in ids) {
      final timetable = getSitTimetableById(id: id);
      if (timetable != null) {
        res.add(timetable);
      }
    }
    return res;
  }
}
