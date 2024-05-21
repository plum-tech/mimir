import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_status.dart';

import 'save.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class GameStateWordle {
  final GameStatus status;
  final Duration playtime;

  const GameStateWordle({
    this.status = GameStatus.idle,
    this.playtime = Duration.zero,
  });

  GameStateWordle.newGame()
      : status = GameStatus.idle,
        playtime = Duration.zero;

  GameStateWordle.byDefault()
      : status = GameStatus.idle,
        playtime = Duration.zero;

  factory GameStateWordle.fromJson(Map<String, dynamic> json) => _$GameStateWordleFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateWordleToJson(this);

  factory GameStateWordle.fromSave(SaveWordle save) {
    return GameStateWordle(
      playtime: save.playtime,
      status: GameStatus.running,
    );
  }

  SaveWordle toSave() {
    return SaveWordle(
      playtime: playtime,
    );
  }
}
