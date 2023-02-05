import 'package:json_annotation/json_annotation.dart';

import '../using.dart';

part 'record.g.dart';

/// REAL. THE PAYLOAD IS IN PINYIN. DONT BLAME ANYONE BUT THE SCHOOL.
/// More reading: https://github.com/sunnysab/zf-tools/blob/master/TRANSLATION.md
@JsonSerializable()
@HiveType(typeId: HiveTypeId.reportHistory)
class ReportHistory {
  /// 上报日期 "yyyyMMdd"
  @JsonKey(name: 'batchno')
  @HiveField(0)
  final int date;

  /// 当前所在位置 "省-市-区县"
  @JsonKey(name: 'position')
  @HiveField(1)
  final String place;

  /// 体温是否正常 （≤37.3℃）
  @JsonKey(name: 'wendu')
  @HiveField(2)
  final int isNormal;

  const ReportHistory(this.date, this.place, this.isNormal);

  factory ReportHistory.fromJson(Map<String, dynamic> json) => _$ReportHistoryFromJson(json);
}
