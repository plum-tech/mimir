import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mimir/game/entity/game_result.dart';
import 'package:mimir/game/entity/record.dart';
import 'package:mimir/game/wordle/entity/blueprint.dart';
import 'package:uuid/uuid.dart';

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
    required super.uuid,
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
    const blueprint = BlueprintWordle(
      word: "APPLE",
    );
    return RecordWordle(
      uuid: const Uuid().v4(),
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
