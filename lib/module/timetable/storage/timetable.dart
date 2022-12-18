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

class TimetableStorage {
  final Box<dynamic> box;

  TimetableStorage(this.box);

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.get(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.put(_K.lastDisplayMode, newValue?.index);

  List<String>? get timetableIds => box.get(_K.timetableIds);

  set timetableIds(List<String>? newValue) => box.put(_K.timetableIds, newValue);

  SitTimetable? getSitTimetableBy({required String id}) =>
      mimir.restoreByExactType<SitTimetable>(box.get(_K.makeTimetableKey(id)));

  void setSitTimetable(SitTimetable? timetable, {required String byId}) => box.put(_K.makeTimetableKey(byId),
      timetable == null ? null : mimir.parseToJson<SitTimetable>(timetable, enableTypeAnnotation: false));

  String? get currentTimetableId => box.get(_K.currentTimetableId);

  set currentTimetableId(String? newValue) => box.put(_K.currentTimetableId, newValue);

  set useOldSchoolColors(bool? newV) => box.put(_K.useOldSchoolPalette, newV);

  bool? get useOldSchoolColors => box.get(_K.useOldSchoolPalette);

  set useNewUI(bool? newV) => box.put(_K.useNewUI, newV);

  bool? get useNewUI => box.get(_K.useNewUI);
}

extension TimetableStorageEx on TimetableStorage {
  bool get hasAnyTimetable => timetableIds?.isNotEmpty ?? false;

  /// Delete the timetable by [id].
  /// If [SitTimetable.currentTimetableId] equals to [id], it will be also cleared.
  void deleteTimetableOf(String id) {
    final ids = timetableIds;
    if (ids == null) return;
    ids.remove(id);
    if (currentTimetableId == id) {
      currentTimetableId = null;
    }
  }

  void addTimetable(SitTimetable timetable) {
    final id = timetable.id;
    final ids = timetableIds ?? <String>[];
    ids.add(id);
    setSitTimetable(timetable, byId: id);
    timetableIds = ids;
  }

  List<SitTimetable> getAllSitTimetables() {
    final ids = timetableIds;
    if (ids == null) return const [];
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
