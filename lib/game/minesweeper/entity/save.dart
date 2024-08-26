import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/utils/list2d/list2d.dart';

import 'mode.dart';
import 'cell.dart';

part "save.g.dart";

List2D<Cell4Save> _defaultCells() {
  return List2D.generate(
    GameModeMinesweeper.defaultRows,
    GameModeMinesweeper.defaultColumns,
    (row, column, index) => const Cell4Save(),
  );
}

@JsonSerializable()
class Cell4Save {
  final bool mine;
  final CellState state;

  const Cell4Save({
    this.mine = false,
    this.state = CellState.covered,
  });

  Map<String, dynamic> toJson() => _$Cell4SaveToJson(this);

  factory Cell4Save.fromJson(Map<String, dynamic> json) => _$Cell4SaveFromJson(json);
}

@JsonSerializable()
class SaveMinesweeper {
  @JsonKey(defaultValue: _defaultCells)
  final List2D<Cell4Save> cells;
  final Duration playtime;
  final GameModeMinesweeper mode;
  final ({int row, int column}) firstClick;

  const SaveMinesweeper({
    required this.cells,
    this.playtime = Duration.zero,
    this.mode = GameModeMinesweeper.easy,
    required this.firstClick,
  });

  Map<String, dynamic> toJson() => _$SaveMinesweeperToJson(this);

  factory SaveMinesweeper.fromJson(Map<String, dynamic> json) => _$SaveMinesweeperFromJson(json);
}
