import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable()
class HourlyBill {
  /// 充值金额
  @JsonKey()
  final double charge;

  /// 消费金额
  @JsonKey()
  final double consumption;

  /// 时间
  @JsonKey()
  final DateTime time;

  HourlyBill(this.charge, this.consumption, this.time);

  factory HourlyBill.fromJson(Map<String, dynamic> json) => _$HourlyBillFromJson(json);

  @override
  String toString() {
    return 'HourlyBill{charge: $charge, consumption: $consumption, time: $time}';
  }
}

@JsonSerializable()
class DailyBill {
  /// 充值金额
  @JsonKey()
  final double charge;

  /// 消费金额
  @JsonKey()
  final double consumption;

  /// 时间
  @JsonKey()
  final DateTime date;

  DailyBill(this.charge, this.consumption, this.date);

  factory DailyBill.fromJson(Map<String, dynamic> json) => _$DailyBillFromJson(json);
}
