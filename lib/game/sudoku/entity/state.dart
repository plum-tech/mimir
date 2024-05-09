import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_state.dart';

import 'board.dart';
import 'mode.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class StateSudoku {
  final GameState state;
  final GameMode mode;
  final SudokuBoard board;
  final Duration playtime;

  const StateSudoku({
    required this.state,
    required this.mode,
    required this.board,
    this.playtime = Duration.zero,
  });

  StateSudoku.byDefault()
      : state = GameState.idle,
        mode = GameMode.easy,
        playtime = Duration.zero,
        board = SudokuBoard.byDefault();

  factory StateSudoku.fromJson(Map<String, dynamic> json) => _$StateSudokuFromJson(json);

  Map<String, dynamic> toJson() => _$StateSudokuToJson(this);
}
