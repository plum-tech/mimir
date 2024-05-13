import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_status.dart';
import 'package:sit/game/sudoku/save.dart';

import 'board.dart';
import 'mode.dart';
import 'note.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class GameStateSudoku {
  final GameStatus status;
  final GameModeSudoku mode;
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
        notes = List.generate(sudokuSides * sudokuSides, (index) => const SudokuCellNote.empty());

  GameStateSudoku.byDefault()
      : status = GameStatus.idle,
        mode = GameModeSudoku.easy,
        playtime = Duration.zero,
        board = SudokuBoard.byDefault(),
        notes = List.generate(sudokuSides * sudokuSides, (index) => const SudokuCellNote.empty());

  factory GameStateSudoku.fromJson(Map<String, dynamic> json) => _$GameStateSudokuFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateSudokuToJson(this);

  factory GameStateSudoku.fromSave(SaveSudoku save) {
    final board = SudokuBoard.fromSave(save);
    return GameStateSudoku(
      mode: save.mode,
      board: board,
      playtime: save.playtime,
      status: GameStatus.running,
      notes: save.notes,
    );
  }

  SaveSudoku toSave() {
    return SaveSudoku(
      cells: board.toSave(),
      playtime: playtime,
      mode: mode,
      notes: notes,
    );
  }
}
