import "package:flutter/foundation.dart";
import '../manager/logic.dart';
import 'package:logger/logger.dart';
import 'dart:math';
import 'cell.dart';

class Board {
  var _mines = -1;
  final int rows;
  final int cols;
  late List<Cell> _board;

  static const _nearbyDelta = [(-1, 1), (0, 1), (1, 1), (-1, 0), /*(0,0)*/ (1, 0), (-1, -1), (0, -1), (1, -1)];

  Board({required this.rows, required this.cols}) {
    _board = List.generate(rows * cols , (index) => Cell(row: index ~/ cols, col: index % cols));
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

  int get mines => max(0, _mines);

  bool get started => _mines >= 0;

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
    _mines = number;
    int beginSafeRow = clickRow - 1 < 0 ? 0 : clickRow - 1;
    int endSafeRow = clickRow + 1 >= rows ? rows - 1 : clickRow + 1;
    int beginSafeCol = clickCol - 1 < 0 ? 0 : clickCol - 1;
    int endSafeCol = clickCol + 1 >= cols ? cols - 1 : clickCol + 1;
    var cnt = 0;
    while (cnt < number) {
      var value = Random().nextInt(cols * rows);
      var col = value % cols;
      var row = (value / cols).floor();
      final cell = getCell(row: row, col: col);
      if (!cell.mine && !((row >= beginSafeRow && row <= endSafeRow) && (col >= beginSafeCol && col <= endSafeCol))) {
        cell.mine = true;
        _addRoundCellMineNum(row: row, col: col); // count as mine created
        cnt += 1;
      }
    }
  }

  void _addRoundCellMineNum({required row, required col}) {
    for (final neighbor in iterateAround(cell: getCell(row: row, col: col))) {
      neighbor.minesAround += 1;
    }
  }

  Cell getCell({required row, required col}) {
    return _board[row * cols + col];
  }

  void changeCell({required row, required col, required state}) {
    getCell(row: row, col: col).state = state;
  }

  Iterable<Cell> iterateAround({required Cell cell}) sync* {
    for (final (dx, dy) in _nearbyDelta) {
      final row = cell.row + dx;
      final col = cell.col + dy;
      if (_isInRange(row: row, col: col)) {
        yield getCell(row: row, col: col);
      }
    }
  }

  Iterable<Cell> iterateAllCells() sync* {
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < cols; column++) {
        yield getCell(row: row, col: column);
      }
    }
  }

  bool _isInRange({required int row, required int col}) {
    return 0 <= row && row < rows && 0 <= col && col < cols;
  }
}
