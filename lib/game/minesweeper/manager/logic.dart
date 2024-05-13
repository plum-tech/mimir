import 'package:sit/game/minesweeper/save.dart';
import 'package:sit/game/utils.dart';

import '../entity/mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import '../entity/board.dart';
import '../entity/cell.dart';
import '../entity/state.dart';
import 'package:sit/game/entity/game_status.dart';

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
    if (state.status == GameStatus.idle) {
      final mode = state.mode;
      state = state.copyWith(
        status: GameStatus.running,
        board: CellBoard.withMines(
          rows: mode.gameRows,
          columns: mode.gameColumns,
          mines: mode.gameMines,
          rowExclude: cell.row,
          columnExclude: cell.column,
        ),
      );
    }
    if (cell.state == CellState.covered) {
      _changeCell(cell: cell, state: CellState.blank);
      // Check Game State
      if (cell.mine) {
        state = state.copyWith(
          status: GameStatus.gameOver,
        );
        applyGameHapticFeedback(HapticFeedbackIntensity.heavy);
      } else {
        _digAroundIfSafe(cell: cell);
        if (checkWin()) {
          state = state.copyWith(
            status: GameStatus.victory,
          );
        }
      }
    } else {
      assert(false, "$cell");
    }
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
    assert(state.status == GameStatus.running, "Game not yet started");
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
    assert(state.status == GameStatus.running, "Game not yet started");
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
    assert(state.status == GameStatus.running, "Game not yet started");
    if (cell.state == CellState.flag) {
      _changeCell(cell: cell, state: CellState.covered);
    } else if (cell.state == CellState.covered) {
      _changeCell(cell: cell, state: CellState.flag);
    } else {
      assert(false, "$cell");
    }
  }

  void flag({required Cell cell}) {
    assert(state.status == GameStatus.running, "Game not yet started");
    if (cell.state == CellState.covered) {
      _changeCell(cell: cell, state: CellState.flag);
    } else {
      assert(false, "$cell");
    }
  }

  void removeFlag({required Cell cell}) {
    assert(state.status == GameStatus.running, "Game not yet started");
    if (cell.state == CellState.flag) {
      _changeCell(cell: cell, state: CellState.covered);
    } else {
      assert(false, "$cell");
    }
  }

  Future<void> save() async {
    if (state.status.shouldSave) {
      await SaveMinesweeper.storage.save(state.toSave());
    } else {
      await SaveMinesweeper.storage.delete();
    }
  }
}
