import 'package:json_annotation/json_annotation.dart';
import 'package:sit/hive/type_id.dart';

part 'balance.g.dart';

double _parseBalance(String raw) {
  return double.tryParse(raw) ?? 0;
}

/// 0.61 RMB/kWh
const rmbPerKwh = 0.61;

/// ```json
/// [{
///   "RoomName":"105604",
///   "BaseBalance":"53.6640",
///   "ElecBalance":"0.0000",
///   "Balance":"53.6640"
/// }]
/// ```
@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeElectricity.balance)
class ElectricityBalance {
  @JsonKey(name: "Balance", fromJson: _parseBalance)
  @HiveField(0)
  final double balance;

  @JsonKey(name: "BaseBalance", fromJson: _parseBalance)
  @HiveField(1)
  final double baseBalance;

  @JsonKey(name: "ElecBalance", fromJson: _parseBalance)
  @HiveField(2)
  final double electricityBalance;

  @JsonKey(name: "RoomName")
  @HiveField(3)
  final String roomNumber;

  const ElectricityBalance({
    required this.roomNumber,
    required this.balance,
    required this.baseBalance,
    required this.electricityBalance,
  });

  factory ElectricityBalance.fromJson(Map<String, dynamic> json) => _$ElectricityBalanceFromJson(json);

  double get remainingPower => balance / rmbPerKwh;
}
