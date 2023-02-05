import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/l10n/extension.dart';

part 'home.g.dart';

@HiveType(typeId: HiveTypeId.ftype)
enum FType {
  /// Separator
  @HiveField(0)
  separator,

  /// Timetable
  @HiveField(1)
  timetable,

  /// Report temperature
  @HiveField(2)
  reportTemp,

  /// Examination arrangement
  @HiveField(3)
  examArr,

  /// Second class activity
  @HiveField(4)
  activity,

  /// Expense tracker
  @HiveField(5)
  expense,

  /// Examination result
  @HiveField(6)
  examResult,

  /// Library
  @HiveField(7)
  library,

  /// Application of SIT
  @HiveField(8)
  application,

  /// Education email
  @HiveField(9)
  eduEmail,

  /// OA announcement
  @HiveField(10)
  oaAnnouncement,

  /// Yellow page of SIT
  @HiveField(11)
  yellowPages,

  /// 扫码
  @HiveField(13)
  scanner,

  /// 电费查询
  @HiveField(14)
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
      case FType.reportTemp:
        return i18n.ftype_reportTemp;
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
      case FType.reportTemp:
        return i18n.ftype_reportTemp_desc;
    }
  }
}
