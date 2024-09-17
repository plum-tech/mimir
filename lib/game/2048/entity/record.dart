import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/game/entity/record.dart';
import 'package:uuid/uuid.dart';

part "record.g.dart";

@JsonSerializable()
class Record2048 extends GameRecord {
  final int score;
  final int maxNumber;

  const Record2048({
    required super.uuid,
    required super.ts,
    required this.score,
    required this.maxNumber,
  });

  factory Record2048.createFrom({
    required int score,
    required int maxNumber,
  }) {
    return Record2048(
      uuid: const Uuid().v4(),
      ts: DateTime.now(),
      maxNumber: maxNumber,
      score: score,
    );
  }

  bool get hasVictory => maxNumber >= 2048;

  Map<String, dynamic> toJson() => _$Record2048ToJson(this);

  factory Record2048.fromJson(Map<String, dynamic> json) => _$Record2048FromJson(json);
}
