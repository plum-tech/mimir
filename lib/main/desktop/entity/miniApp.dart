import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/hive/type_id.dart';

part 'miniApp.g.dart';

const _ns = "miniApp";

@HiveType(typeId: HiveTypeId.miniApp)
enum MiniApp {
  /// Separator
  @HiveField(0)
  separator,

  /// Timetable
  @HiveField(1)
  timetable,

  /// Examination arrangement
  @HiveField(2)
  examArr,

  /// Second class activity
  @HiveField(3)
  activity,

  /// Expense tracker
  @HiveField(4)
  expense,

  /// Examination result
  @HiveField(5)
  examResult,

  /// Library
  @HiveField(6)
  library,

  /// Application of SIT
  @HiveField(7)
  application,

  /// Education email
  @HiveField(8)
  eduEmail,

  /// OA announcement
  @HiveField(9)
  oaAnnouncement,

  /// Yellow page of SIT
  @HiveField(10)
  yellowPages,

  /// 扫码
  @HiveField(11)
  scanner,

  /// 电费查询
  @HiveField(12)
  elecBill;

  String l10nName() => "$_ns.$name.name".tr();

  String l10nDesc() => "$_ns.$name.desc".tr();
}
