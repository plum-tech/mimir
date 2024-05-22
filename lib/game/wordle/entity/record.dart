import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_result.dart';
import 'package:sit/game/entity/record.dart';
import 'package:sit/game/wordle/entity/blueprint.dart';

import 'vocabulary.dart';

part "record.g.dart";

@JsonSerializable()
@immutable
class RecordWordle extends GameRecord {
  final GameResult result;
  final Duration playtime;
  final List<String> attempts;
  final WordleVocabulary vocabulary;
  final String blueprint;

  const RecordWordle({
    required super.ts,
    required this.result,
    required this.playtime,
    required this.vocabulary,
    required this.attempts,
    required this.blueprint,
  });

  factory RecordWordle.createFrom({
    required Duration playtime,
    required GameResult result,
    required List<String> attempts,
    required WordleVocabulary vocabulary,
  }) {
    final blueprint = BlueprintWordle(
      word: "APPLE",
    );
    return RecordWordle(
      ts: DateTime.now(),
      result: result,
      playtime: playtime,
      attempts: attempts,
      vocabulary: vocabulary,
      blueprint: blueprint.build(),
    );
  }

  Map<String, dynamic> toJson() => _$RecordWordleToJson(this);

  factory RecordWordle.fromJson(Map<String, dynamic> json) => _$RecordWordleFromJson(json);
}
