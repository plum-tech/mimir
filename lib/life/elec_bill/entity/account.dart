import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

part 'account.g.dart';

double _parseBalance(String raw) {
  return double.tryParse(raw) ?? 0;
}

/// ```json
/// [{
///   "RoomName":"105604",
///   "BaseBalance":"53.6640",
///   "ElecBalance":"0.0000",
///   "Balance":"53.6640"
/// }]
/// ```
@JsonSerializable()
@HiveType(typeId: HiveTypeId.balance)
class Balance {
  @JsonKey(name: "Balance", fromJson: _parseBalance)
  @HiveField(0)
  final double balance;

  @JsonKey(name: "RoomName")
  @HiveField(2)
  final String roomNumber;

  Balance(this.roomNumber, this.balance);

  factory Balance.fromJson(Map<String, dynamic> json) => _$BalanceFromJson(json);
}
