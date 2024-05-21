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
  final String blueprint;
  final WordleVocabulary vocabulary;

  const RecordWordle({
    required super.ts,
    required this.result,
    required this.playtime,
    required this.blueprint,
    required this.vocabulary,
  });

  factory RecordWordle.createFrom({
    required Duration playtime,
    required GameResult result,
    required WordleVocabulary vocabulary,
  }) {
    final blueprint = BlueprintWordle(
      word: "APPLE",
    );
    return RecordWordle(
      ts: DateTime.now(),
      result: result,
      playtime: playtime,
      vocabulary: vocabulary,
      blueprint: blueprint.build(),
    );
  }

  Map<String, dynamic> toJson() => _$RecordWordleToJson(this);

  factory RecordWordle.fromJson(Map<String, dynamic> json) => _$RecordWordleFromJson(json);
}
