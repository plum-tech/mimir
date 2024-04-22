import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/game_state.dart';

import '../save.dart';
import 'board.dart';
import 'mode.dart';

part "state.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
class GameStateMinesweeper {
  @JsonKey()
  final GameState state;
  @JsonKey(toJson: GameMode.toJson, fromJson: GameMode.fromJson)
  final GameMode mode;
  @JsonKey()
  final CellBoard board;

  const GameStateMinesweeper({
    this.state = GameState.idle,
    required this.mode,
    required this.board,
  });

  GameStateMinesweeper.byDefault()
      : state = GameState.idle,
        mode = GameMode.easy,
        board = CellBoard.empty(rows: GameMode.easy.gameRows, columns: GameMode.easy.gameColumns);

  int get rows => board.rows;

  int get columns => board.columns;

  Map<String, dynamic> toJson() => _$GameStateMinesweeperToJson(this);

  factory GameStateMinesweeper.fromJson(Map<String, dynamic> json) => _$GameStateMinesweeperFromJson(json);
//
// factory GameStateMinesweeper.fromSave(SaveMinesweeper save) {
//   final cells = save.cells
//       .mapIndexed(
//         (index, cell) => _CellBuilder(row: index ~/ save.columns, column: index % save.columns)
//           ..mine = cell.mine
//           ..state = cell.state,
//       )
//       .toList();
//   final builder = _CellBoardBuilder(rows: save.rows, columns: save.columns, cells: cells);
//   return builder.build();
// }
//
// GameStateMinesweeper toSave() {
//   return SaveMinesweeper(
//     rows: rows,
//     columns: columns,
//     cells: cells.map((cell) => Cell4Save(mine: cell.mine, state: cell.state)).toList(),
//   );
// }
}
