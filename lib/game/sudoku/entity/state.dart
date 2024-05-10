import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_status.dart';

import 'board.dart';
import 'mode.dart';
import 'note.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class GameStateSudoku {
  final GameStatus status;
  final GameMode mode;
  final SudokuBoard board;
  final Duration playtime;
  final List<SudokuCellNote> notes;

  const GameStateSudoku({
    this.status = GameStatus.idle,
    required this.mode,
    required this.board,
    this.playtime = Duration.zero,
    required this.notes,
  });

  GameStateSudoku.newGame({
    required this.mode,
    required this.board,
  })  : status = GameStatus.idle,
        playtime = Duration.zero,
        notes = List.generate(81, (index) => const SudokuCellNote.empty());

  GameStateSudoku.byDefault()
      : status = GameStatus.idle,
        mode = GameMode.easy,
        playtime = Duration.zero,
        board = SudokuBoard.byDefault(),
        notes = List.generate(81, (index) => const SudokuCellNote.empty());

  factory GameStateSudoku.fromJson(Map<String, dynamic> json) => _$GameStateSudokuFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateSudokuToJson(this);
}
