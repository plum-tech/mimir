import 'package:mimir/game/entity/game_result.dart';
import 'package:mimir/game/minesweeper/entity/record.dart';
import 'package:mimir/game/minesweeper/entity/save.dart';
import 'package:mimir/game/utils.dart';

import '../entity/mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import '../entity/board.dart';
import '../entity/cell.dart';
import '../entity/state.dart';
import 'package:mimir/game/entity/game_status.dart';

import '../storage.dart';

// Debug Tool
final logger = Logger();

class GameLogic extends StateNotifier<GameStateMinesweeper> {
  GameLogic([GameStateMinesweeper? initial]) : super(initial ?? GameStateMinesweeper.byDefault());

  void initGame({required GameModeMinesweeper gameMode}) {
    final board = CellBoard.empty(rows: state.mode.gameRows, columns: state.mode.gameColumns);
    state = GameStateMinesweeper(mode: gameMode, board: board);
    if (kDebugMode) {
      logger.log(Level.info, "Game Init Finished");
    }
  }

  void fromSave(SaveMinesweeper save) {
    state = GameStateMinesweeper.fromSave(save);
    final firstClick = save.firstClick;
    dig(cell: state.board.getCell(row: firstClick.row, column: firstClick.column));
  }

  Duration get playtime => state.playtime;

  set playtime(Duration playtime) => state = state.copyWith(
        playtime: playtime,
      );

  Cell getCell({required row, required col}) {
    return state.board.getCell(row: row, column: col);
  }

  void _changeCell({required Cell cell, required CellState state}) {
    this.state = this.state.copyWith(
          board: this.state.board.changeCell(
                row: cell.row,
                column: cell.column,
                state: state,
              ),
        );
  }

  void dig({required Cell cell}) {
    assert(state.status != GameStatus.gameOver && state.status != GameStatus.victory, "Game is already over");
    // Generating mines on first dig
    if (state.status == GameStatus.idle && state.firstClick == null) {
      final mode = state.mode;
      final firstClick = (row: cell.row, column: cell.column);
      state = state.copyWith(
        firstClick: firstClick,
        status: GameStatus.running,
        board: CellBoard.withMines(
          rows: mode.gameRows,
          columns: mode.gameColumns,
          mines: mode.gameMines,
          firstClick: firstClick,
        ),
      );
    }
    if (cell.state == CellState.covered) {
      _changeCell(cell: cell, state: CellState.blank);
      // Check Game State
      if (cell.mine) {
        onGameOver();
      } else {
        _digAroundIfSafe(cell: cell);
        if (checkWin()) {
          onVictory();
        }
      }
    }
  }

  void onVictory() {
    if (!state.status.canPlay) return;
    state = state.copyWith(
      status: GameStatus.victory,
    );
    final firstClick = state.firstClick;
    if (firstClick == null) return;
    StorageMinesweeper.record.add(RecordMinesweeper.createFrom(
      board: state.board,
      playtime: state.playtime,
      mode: state.mode,
      result: GameResult.victory,
      firstClick: firstClick,
    ));
  }

  void onGameOver() {
    if (!state.status.canPlay) return;
    state = state.copyWith(
      status: GameStatus.gameOver,
    );
    final firstClick = state.firstClick;
    if (firstClick == null) return;
    StorageMinesweeper.record.add(RecordMinesweeper.createFrom(
      board: state.board,
      playtime: state.playtime,
      mode: state.mode,
      result: GameResult.gameOver,
      firstClick: firstClick,
    ));
    applyGameHapticFeedback(HapticFeedbackIntensity.heavy);
  }

  void _digAroundIfSafe({required Cell cell}) {
    if (cell.minesAround == 0) {
      for (final neighbor in state.board.iterateAround(row: cell.row, column: cell.column)) {
        if (neighbor.state == CellState.covered && neighbor.minesAround == 0) {
          _changeCell(cell: neighbor, state: CellState.blank);
          _digAroundIfSafe(cell: neighbor);
        } else if (!neighbor.mine && neighbor.state == CellState.covered && neighbor.minesAround != 0) {
          _changeCell(cell: neighbor, state: CellState.blank);
        }
      }
    }
  }

  bool digAroundBesidesFlagged({required Cell cell}) {
    if (!state.status.canPlay) return false;
    bool digAny = false;
    if (state.board.countAroundByState(cell: cell, state: CellState.flag) >= cell.minesAround) {
      for (final neighbor in state.board.iterateAround(row: cell.row, column: cell.column)) {
        if (neighbor.state == CellState.covered) {
          dig(cell: neighbor);
          digAny = true;
        }
      }
    }
    return digAny;
  }

  bool flagRestCovered({required Cell cell}) {
    if (!state.status.canPlay) return false;
    bool flagAny = false;
    final coveredCount = state.board.countAroundByState(cell: cell, state: CellState.covered);
    if (coveredCount == 0) return false;
    final flagCount = state.board.countAroundByState(cell: cell, state: CellState.flag);
    if (coveredCount + flagCount == cell.minesAround) {
      for (final neighbor in state.board.iterateAround(row: cell.row, column: cell.column)) {
        if (neighbor.state == CellState.covered) {
          flag(cell: neighbor);
          flagAny = true;
        }
      }
    }
    return flagAny;
  }

  bool checkWin() {
    var coveredCells = state.board.countAllByState(state: CellState.covered);
    var flagCells = state.board.countAllByState(state: CellState.flag);
    var mineCells = state.board.mines;
    if (kDebugMode) {
      logger.log(
        Level.debug,
        "mines: $mineCells, covers: $coveredCells, flags: $flagCells",
      );
    }
    if (coveredCells + flagCells == mineCells) {
      return true;
    }
    return false;
  }

  void toggleFlag({required Cell cell}) {
    if (!state.status.canPlay) return;
    if (cell.state == CellState.flag) {
      _changeCell(cell: cell, state: CellState.covered);
    } else if (cell.state == CellState.covered) {
      _changeCell(cell: cell, state: CellState.flag);
    } else {
      assert(false, "$cell");
    }
  }

  void flag({required Cell cell}) {
    if (!state.status.canPlay) return;
    if (cell.state == CellState.covered) {
      _changeCell(cell: cell, state: CellState.flag);
    } else {
      assert(false, "$cell");
    }
  }

  void removeFlag({required Cell cell}) {
    if (!state.status.canPlay) return;
    if (cell.state == CellState.flag) {
      _changeCell(cell: cell, state: CellState.covered);
    } else {
      assert(false, "$cell");
    }
  }

  Future<void> save() async {
    if (state.status.shouldSave && state.firstClick != null) {
      await StorageMinesweeper.save.save(state.toSave());
    } else {
      await StorageMinesweeper.save.delete();
    }
  }
}
