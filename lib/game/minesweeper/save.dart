import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/storage/save.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/list2d.dart';

import 'entity/mode.dart';
import 'entity/cell.dart';

part "save.g.dart";

List2D<Cell4Save> _defaultCells() {
  return List2D.generate(
    GameMode.defaultRows,
    GameMode.defaultColumns,
    (row, column) => const Cell4Save(mine: false, state: CellState.covered),
  );
}

@JsonSerializable()
class Cell4Save {
  @JsonKey(defaultValue: false)
  final bool mine;
  @JsonKey(defaultValue: CellState.covered)
  final CellState state;

  const Cell4Save({
    required this.mine,
    required this.state,
  });

  Map<String, dynamic> toJson() => _$Cell4SaveToJson(this);

  factory Cell4Save.fromJson(Map<String, dynamic> json) => _$Cell4SaveFromJson(json);
}

@JsonSerializable()
class SaveMinesweeper {
  @JsonKey(defaultValue: _defaultCells)
  final List2D<Cell4Save> cells;
  final Duration playTime;
  final GameMode mode;

  const SaveMinesweeper({
    required this.cells,
    this.playTime = Duration.zero,
    this.mode = GameMode.easy,
  });

  Map<String, dynamic> toJson() => _$SaveMinesweeperToJson(this);

  factory SaveMinesweeper.fromJson(Map<String, dynamic> json) => _$SaveMinesweeperFromJson(json);

  static final storage = GameSaveStorage<SaveMinesweeper>(
    () => HiveInit.gameMinesweeper,
    prefix: "/minesweeper/1",
    serialize: (save) => save.toJson(),
    deserialize: SaveMinesweeper.fromJson,
  );
}
