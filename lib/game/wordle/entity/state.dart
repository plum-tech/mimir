import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_status.dart';

import 'vocabulary.dart';
import 'save.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class GameStateWordle {
  final String word;
  final List<String> attempts;
  final String input;
  final GameStatus status;
  final Duration playtime;
  final WordleVocabulary vocabulary;

  const GameStateWordle({
    this.status = GameStatus.idle,
    this.playtime = Duration.zero,
    this.vocabulary = WordleVocabulary.all,
    required this.word,
    this.input = "",
    this.attempts = const [],
  });

  const GameStateWordle.newGame({
    required this.word,
    this.vocabulary = WordleVocabulary.all,
  })  : status = GameStatus.idle,
        playtime = Duration.zero,
        input = "",
        attempts = const [];

  const GameStateWordle.byDefault()
      : status = GameStatus.idle,
        playtime = Duration.zero,
        word = "APPLE",
        attempts = const [],
        input = "",
        vocabulary = WordleVocabulary.all;

  factory GameStateWordle.fromJson(Map<String, dynamic> json) => _$GameStateWordleFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateWordleToJson(this);

  factory GameStateWordle.fromSave(SaveWordle save) {
    return GameStateWordle(
      playtime: save.playtime,
      status: GameStatus.running,
      word: save.word,
      attempts: save.attempts,
    );
  }

  SaveWordle toSave() {
    return SaveWordle(
      playtime: playtime,
      word: word,
      attempts: attempts,
    );
  }
}
