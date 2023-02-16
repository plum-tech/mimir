import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/hive/type_id.dart';

part 'ftype.g.dart';
const _ns = "ftype";
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
  elecBill;

  String l10nName()=> "$_ns.$name.name".tr();

  String l10nDesc()=> "$_ns.$name.desc".tr();
}
