import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mimir/hive/using.dart';
import 'package:mimir/mini_apps/symbol.dart';

import '../entity/course.dart';
import '../entity/entity.dart';
import '../events.dart';
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

class TimetableStorage {
  final Box<dynamic> box;

  TimetableStorage(this.box);

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.get(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.put(_K.lastDisplayMode, newValue?.index);

  List<String> get timetableIds => box.get(_K.timetableIds) ?? <String>[];

  set timetableIds(List<String>? newValue) => box.put(_K.timetableIds, newValue);

  SitTimetable? getSitTimetableBy({required String id}) {
    final table = box.get(_K.makeTimetableKey(id));
    return table == null ? null : SitTimetable.fromJson(jsonDecode(table));
  }

  void setSitTimetable(SitTimetable? timetable, {required String byId}) {
    if (timetable == null) {
      box.delete(_K.makeTimetableKey(byId));
    } else {
      box.put(_K.makeTimetableKey(byId), jsonEncode(timetable.toJson()));
    }
  }

  String? get currentTimetableId => box.get(_K.currentTimetableId);

  set currentTimetableId(String? newValue) => box.put(_K.currentTimetableId, newValue);

  ValueListenable<Box<dynamic>> get onCurrentTimetableIdChanged => box.listenable(keys: [_K.currentTimetableId]);

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
      setSitTimetable(null, byId: id);
    }
  }

  void addTimetable(SitTimetable timetable) {
    final id = timetable.id;
    final ids = timetableIds;
    ids.add(id);
    setSitTimetable(timetable, byId: id);
    timetableIds = ids;
  }

  List<SitTimetable> getAllSitTimetables() {
    final ids = timetableIds;
    final res = <SitTimetable>[];
    for (final id in ids) {
      final timetable = getSitTimetableBy(id: id);
      if (timetable != null) {
        res.add(timetable);
      }
    }
    return res;
  }
}
