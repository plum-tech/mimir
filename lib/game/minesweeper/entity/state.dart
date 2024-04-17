import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/game_state.dart';

import 'board.dart';
import 'mode.dart';

part "state.g.dart";

// @JsonSerializable()
@CopyWith(skipFields: true)
class GameStateMinesweeper {
  @JsonKey()
  final GameState state;
  @JsonKey(toJson: GameMode.toJson, fromJson: GameMode.fromJson)
  final GameMode mode;
  @JsonKey()
  final Board board;

  const GameStateMinesweeper({
    required this.state,
    required this.mode,
    required this.board,
  });
  //
  // Map<String, dynamic> toJson() => _$GameStateMinesweeperToJson(this);
  //
  // factory GameStateMinesweeper.fromJson(Map<String, dynamic> json) => _$GameStateMinesweeperFromJson(json);
}
