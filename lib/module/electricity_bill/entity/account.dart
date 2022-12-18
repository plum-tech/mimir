import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../using.dart';

part 'account.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeId.balance)
class Balance {
  /// 余额
  @JsonKey()
  @HiveField(0)
  final double balance;

  /// 余量
  @JsonKey()
  @HiveField(1)
  final double power;

  /// 房间号
  @JsonKey()
  @HiveField(2)
  final int room;

  /// 更新时间
  @JsonKey()
  @HiveField(3)
  final DateTime ts;

  Balance(this.balance, this.power, this.room, this.ts);

  factory Balance.fromJson(Map<String, dynamic> json) => _$BalanceFromJson(json);
}

@JsonSerializable()
class Rank {
  /// 消费
  @JsonKey()
  final double consumption;

  /// 排名
  @JsonKey()
  final int rank;

  /// 房间总数
  @JsonKey()
  final int roomCount;

  Rank(this.consumption, this.rank, this.roomCount);

  factory Rank.fromJson(Map<String, dynamic> json) => _$RankFromJson(json);
}
