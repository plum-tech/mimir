import "package:flutter/foundation.dart";
import '../management/gamelogic.dart';
import 'package:logger/logger.dart';
import 'dart:math';
import 'cellstate.dart';

class MineBoard {
  int mines = -1;
  final int rows;
  final int cols;
  late List<List<Cell>> board;

  static const _nearbyDelta = [(-1, 1), (0, 1), (1, 1), (-1, 0), /*(0,0)*/ (1, 0), (-1, -1), (0, -1), (1, -1)];

  MineBoard({required this.rows, required this.cols}) {
    board = List.generate(rows, (row) => List.generate(cols, (col) => Cell(row: row, col: col)));
    if (kDebugMode) {
      logger.log(Level.info, "MineBoard Init Finished");
    }
  }

  int countAllByState({required state}) {
    var count = 0;
    for (final cell in iterateAllCells()) {
      if (cell.state == state) {
        count += 1;
      }
    }
    return count;
  }

  int countMines() {
    // Return the default mines (required num) first
    if (mines >= 0) {
      return mines;
    } else {
      var count = 0;
      for (final cell in iterateAllCells()) {
        if (cell.mine) {
          count += 1;
        }
      }
      return count;
    }
  }

  int countAroundByState({required Cell cell, required state}) {
    var count = 0;
    for (final cell in iterateAround(cell: cell)) {
      if (cell.state == state) {
        count += 1;
      }
    }
    return count;
  }

  int countAroundMines({required Cell cell}) {
    var count = 0;
    for (final cell in iterateAround(cell: cell)) {
      if (cell.mine) {
        count += 1;
      }
    }
    return count;
  }

  void randomMines({required number, required clickRow, required clickCol}) {
    mines = number;
    int beginSafeRow = clickRow - 1 < 0 ? 0 : clickRow - 1;
    int endSafeRow = clickRow + 1 >= rows ? rows - 1 : clickRow + 1;
    int beginSafeCol = clickCol - 1 < 0 ? 0 : clickCol - 1;
    int endSafeCol = clickCol + 1 >= cols ? cols - 1 : clickCol + 1;
    var cnt = 0;
    while (cnt < number) {
      var value = Random().nextInt(cols * rows);
      var col = value % cols;
      var row = (value / cols).floor();
      if (!board[row][col].mine &&
          !((row >= beginSafeRow && row <= endSafeRow) && (col >= beginSafeCol && col <= endSafeCol))) {
        board[row][col].mine = true;
        _addRoundCellMineNum(row: row, col: col); // count as mine created
        cnt += 1;
      }
    }
  }

  void _addRoundCellMineNum({required row, required col}) {
    for (final neighbor in iterateAround(cell: board[row][col])) {
      neighbor.minesAround += 1;
    }
  }

  Cell getCell({required row, required col}) {
    return board[row][col];
  }

  void changeCell({required row, required col, required state}) {
    board[row][col].state = state;
  }

  Iterable<Cell> iterateAround({required Cell cell}) sync* {
    for (final (dx, dy) in _nearbyDelta) {
      final row = cell.row + dx;
      final col = cell.col + dy;
      if (isInRange(row: row, col: col)) {
        yield board[row][col];
      }
    }
  }

  Iterable<Cell> iterateAllCells() sync* {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        yield board[r][c];
      }
    }
  }

  bool isInRange({required int row, required int col}) {
    return 0 <= row && row < rows && 0 <= col && col < cols;
  }
}
