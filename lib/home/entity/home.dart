import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/l10n/extension.dart';

part 'home.g.dart';

@HiveType(typeId: HiveTypeId.ftype)
enum FType {
  /// 课程表
  @HiveField(2)
  timetable,

  /// 考试安排
  @HiveField(4)
  examArr,

  /// 活动
  @HiveField(6)
  activity,

  /// 消费查询
  @HiveField(7)
  expense,

  /// 成绩查询
  @HiveField(8)
  examResult,

  /// 图书馆
  @HiveField(9)
  library,

  /// 办公
  @HiveField(10)
  application,

  /// Edu 邮箱
  @HiveField(11)
  eduEmail,

  /// OA 公告
  @HiveField(12)
  oaAnnouncement,

  /// 常用电话
  @HiveField(13)
  yellowPages,

  /// 分隔符
  @HiveField(16)
  separator,

  /// 扫码
  @HiveField(18)
  scanner,

  /// 电费查询
  @HiveField(22)
  electricityBill;

  String localized() {
    switch (this) {
      case FType.timetable:
        return i18n.ftype_timetable;
      case FType.examArr:
        return i18n.ftype_examArr;
      case FType.activity:
        return i18n.ftype_activity;
      case FType.expense:
        return i18n.ftype_expense;
      case FType.examResult:
        return i18n.ftype_examResult;
      case FType.library:
        return i18n.ftype_library;
      case FType.application:
        return i18n.ftype_application;
      case FType.eduEmail:
        return i18n.ftype_eduEmail;
      case FType.oaAnnouncement:
        return i18n.ftype_oaAnnouncement;
      case FType.yellowPages:
        return i18n.ftype_yellowPages;
      case FType.separator:
        return i18n.ftype_separator;
      case FType.scanner:
        return i18n.ftype_scanner;
      case FType.electricityBill:
        return i18n.ftype_elecBill;
    }
  }

  String localizedDesc() {
    switch (this) {
      case FType.timetable:
        return i18n.ftype_timetable_desc;
      case FType.examArr:
        return i18n.ftype_examArr_desc;
      case FType.activity:
        return i18n.ftype_activity_desc;
      case FType.expense:
        return i18n.ftype_expense_desc;
      case FType.examResult:
        return i18n.ftype_examResult_desc;
      case FType.library:
        return i18n.ftype_library_desc;
      case FType.application:
        return i18n.ftype_application_desc;
      case FType.eduEmail:
        return i18n.ftype_eduEmail_desc;
      case FType.oaAnnouncement:
        return i18n.ftype_oaAnnouncement_desc;
      case FType.yellowPages:
        return i18n.ftype_yellowPages_desc;
      case FType.separator:
        return i18n.ftype_separator_desc;
      case FType.scanner:
        return i18n.ftype_scanner_desc;
      case FType.electricityBill:
        return i18n.ftype_elecBill_desc;
    }
  }
}
