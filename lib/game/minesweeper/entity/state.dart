import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/game_state.dart';

import '../save.dart';
import 'board.dart';
import 'mode.dart';

part "state.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
@immutable
class GameStateMinesweeper {
  final GameState state;
  final GameMode mode;
  final CellBoard board;
  final Duration playTime;

  const GameStateMinesweeper({
    this.state = GameState.idle,
    required this.mode,
    required this.board,
    this.playTime = Duration.zero,
  });

  GameStateMinesweeper.byDefault()
      : state = GameState.idle,
        mode = GameMode.easy,
        playTime = Duration.zero,
        board = CellBoard.empty(rows: GameMode.easy.gameRows, columns: GameMode.easy.gameColumns);

  int get rows => board.rows;

  int get columns => board.columns;

  Map<String, dynamic> toJson() => _$GameStateMinesweeperToJson(this);

  factory GameStateMinesweeper.fromJson(Map<String, dynamic> json) => _$GameStateMinesweeperFromJson(json);

  factory GameStateMinesweeper.fromSave(SaveMinesweeper save) {
    final board = CellBoard.fromSave(save);
    return GameStateMinesweeper(
      mode: save.mode,
      board: board,
      playTime: save.playTime,
    );
  }

  SaveMinesweeper toSave() {
    return SaveMinesweeper(
      rows: rows,
      columns: columns,
      cells: board.cells.map((cell) => Cell4Save(mine: cell.mine, state: cell.state)).toList(),
      playTime: playTime,
    );
  }
}
