import '../entity/course.dart';
import '../entity/meta.dart';
import '../events.dart';
import '../using.dart';

String buildTableName(SchoolYear schoolYear, Semester semester) => '${schoolYear.year!}-${semester.index}';

class TimetableKeys {
  static const _namespace = '/timetable';

  /// 当前的显示模式
  static const lastMode = '$_namespace/lastMode';

  /// 课表相关数据的命名空间
  static const table = '$_namespace/table';

  /// 课表名
  static const tableNames = '$table/names';

  /// 维护多个课表的元数据
  static String buildTableMetaKeyByName(name) => '$table/metas/${name.hashCode.toRadixString(16)}'; // 名称不能存中文在路径中需要哈希一下

  /// 通过课表名称获取课表路径
  static String buildTableCoursesKeyByName(name) => '$table/courses/${name.hashCode.toRadixString(16)}';

  /// 当前使用的课表名称
  static const currentTableName = '$_namespace/currentTableName';

  /// 当前课表显示的起始日期
  static const startDate = '$_namespace/startDate';

  // TODO: Remove this and add a new personalization system.
  static const useOldSchoolColors = "$_namespace/useOldSchoolColors";
}

class TimetableStorage {
  final Box<dynamic> box;

  const TimetableStorage(this.box);

  List<String>? get tableNames => box.get(TimetableKeys.tableNames);

  set tableNames(List<String>? foo) => box.put(TimetableKeys.tableNames, foo);

  /// 通过课表名获取课表
  List<Course>? getTableCourseByName(String name) =>
      (box.get(TimetableKeys.buildTableCoursesKeyByName(name)) as List<dynamic>).map((e) => e as Course).toList();

  /// 添加一张课表
  void addTableCourses(String name, List<Course> table) =>
      box.put(TimetableKeys.buildTableCoursesKeyByName(name), table);

  /// 通过课表名获取课表元数据
  TimetableMetaLegacy? getTableMetaByName(String name) => box.get(TimetableKeys.buildTableMetaKeyByName(name));

  /// 通过课表名添加课表元数据
  void addTableMeta(String name, TimetableMetaLegacy? foo) => box.put(TimetableKeys.buildTableMetaKeyByName(name), foo);

  /// 添加课表
  void addTable(TimetableMetaLegacy meta, List<Course> courses) {
    tableNames = [meta.name, ...((tableNames ?? []).where((n) => n != meta.name))];
    addTableMeta(meta.name, meta);
    addTableCourses(meta.name, courses);
    currentTableName ??= meta.name;
  }

  bool get hasAnyTimetable => tableNames?.isNotEmpty ?? false;

  /// 删除课表
  void removeTable(String name) {
    // 如果删除的是当前正在使用的课表
    if (name == currentTableName) {
      currentTableName = null;
    }
    final newTableNames = (tableNames ?? []).where((n) => n != name).toList();
    box.delete(TimetableKeys.buildTableMetaKeyByName(name));
    box.delete(TimetableKeys.buildTableCoursesKeyByName(name));
    // If there is no timetable selected, find next one.
    if (currentTableName == null && newTableNames.isNotEmpty) {
      currentTableName = newTableNames.first;
    }
    tableNames = newTableNames;
  }

  String? get currentTableName => box.get(TimetableKeys.currentTableName);

  set currentTableName(String? name) {
    eventBus.fire(CurrentTimetableChangeEvent(selected: name));
    box.put(TimetableKeys.currentTableName, name);
  }

  List<Course>? get currentTableCourses {
    if (currentTableName == null) return null;
    return getTableCourseByName(currentTableName!);
  }

  TimetableMetaLegacy? get currentTableMeta {
    if (currentTableName == null) return null;
    return getTableMetaByName(currentTableName!);
  }

  DisplayMode? get lastMode {
    final idx = box.get(TimetableKeys.lastMode);
    if (idx == null) return null;
    return DisplayMode.values[idx];
  }

  set lastMode(DisplayMode? foo) => box.put(TimetableKeys.lastMode, foo?.index);

  set useOldSchoolColors(bool? newV) => box.put(TimetableKeys.useOldSchoolColors, newV);

  bool? get useOldSchoolColors => box.get(TimetableKeys.useOldSchoolColors);
}
