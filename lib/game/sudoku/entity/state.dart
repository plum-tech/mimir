import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_status.dart';

import 'board.dart';
import 'mode.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class GameStateSudoku {
  final GameStatus status;
  final GameMode mode;
  final SudokuBoard board;
  final Duration playtime;

  const GameStateSudoku({
    this.status = GameStatus.idle,
    required this.mode,
    required this.board,
    this.playtime = Duration.zero,
  });

  GameStateSudoku.byDefault()
      : status = GameStatus.idle,
        mode = GameMode.easy,
        playtime = Duration.zero,
        board = SudokuBoard.byDefault();

  factory GameStateSudoku.fromJson(Map<String, dynamic> json) => _$GameStateSudokuFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateSudokuToJson(this);
}
