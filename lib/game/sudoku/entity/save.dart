import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/game/storage/save.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/list2d/list2d.dart';

import 'mode.dart';
import 'board.dart';
import 'note.dart';

part "save.g.dart";

List2D<Cell4Save> _defaultCells() {
  return List2D.generate(
    sudokuSides,
    sudokuSides,
    (row, column, index) => const Cell4Save(),
  );
}

@JsonSerializable()
class Cell4Save {
  final int userInput;
  final int correctValue;

  const Cell4Save({
    this.userInput = SudokuCell.disableInputNumber,
    this.correctValue = SudokuCell.emptyInputNumber,
  });

  Map<String, dynamic> toJson() => _$Cell4SaveToJson(this);

  factory Cell4Save.fromJson(Map<String, dynamic> json) => _$Cell4SaveFromJson(json);
}

List<SudokuCellNote> _defaultNotes() {
  return List.generate(sudokuSides * sudokuSides, (index) => const SudokuCellNote.empty());
}

@JsonSerializable()
class SaveSudoku {
  @JsonKey(defaultValue: _defaultCells)
  final List2D<Cell4Save> cells;
  final Duration playtime;
  final GameModeSudoku mode;
  @JsonKey(defaultValue: _defaultNotes)
  final List<SudokuCellNote> notes;

  const SaveSudoku({
    required this.cells,
    this.playtime = Duration.zero,
    this.mode = GameModeSudoku.easy,
    required this.notes,
  });

  Map<String, dynamic> toJson() => _$SaveSudokuToJson(this);

  factory SaveSudoku.fromJson(Map<String, dynamic> json) => _$SaveSudokuFromJson(json);
}
