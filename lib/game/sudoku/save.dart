import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/storage/save.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/list2d/list2d.dart';

import 'entity/mode.dart';
import 'entity/board.dart';
import 'entity/note.dart';

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
  final GameMode mode;
  @JsonKey(defaultValue: _defaultNotes)
  final List<SudokuCellNote> notes;

  const SaveSudoku({
    required this.cells,
    this.playtime = Duration.zero,
    this.mode = GameMode.easy,
    required this.notes,
  });

  Map<String, dynamic> toJson() => _$SaveSudokuToJson(this);

  factory SaveSudoku.fromJson(Map<String, dynamic> json) => _$SaveSudokuFromJson(json);

  static final storage = GameSaveStorage<SaveSudoku>(
    () => HiveInit.gameSudoku,
    prefix: "/minesweeper/1",
    serialize: (save) => save.toJson(),
    deserialize: SaveSudoku.fromJson,
  );
}
