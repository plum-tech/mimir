import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/record.dart';

part "record.g.dart";

@JsonSerializable()
class Record2048 extends GameRecord {
  @JsonKey()
  final int score;
  @JsonKey()
  final int maxNumber;

  const Record2048({
    required super.ts,
    required this.score,
    required this.maxNumber,
  });

  Map<String, dynamic> toJson() => _$Record2048ToJson(this);

  factory Record2048.fromJson(Map<String, dynamic> json) => _$Record2048FromJson(json);
}
