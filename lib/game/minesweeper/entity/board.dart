import 'package:collection/collection.dart';
import "package:flutter/foundation.dart";
import '../manager/logic.dart';
import 'package:logger/logger.dart';
import 'dart:math';
import '../save.dart';
import 'cell.dart';

// @JsonSerializable()
class Board {
  var _mines = -1;
  final int rows;
  final int columns;
  late List<Cell> _cells;

  static const _nearbyDelta = [(-1, 1), (0, 1), (1, 1), (-1, 0), /*(0,0)*/ (1, 0), (-1, -1), (0, -1), (1, -1)];
  static const _nearbyDeltaAndThis = [..._nearbyDelta, (0, 0)];

  Board({required this.rows, required this.columns}) {
    _cells = List.generate(rows * columns, (index) => Cell(row: index ~/ columns, col: index % columns));
    if (kDebugMode) {
      logger.log(Level.info, "MineBoard Init Finished");
    }
  }

  Board._({
    required this.rows,
    required this.columns,
    required List<Cell> board,
    required int mines,
  })  : _cells = board,
        _mines = mines;

  factory Board.fromSave(SaveMinesweeper save) {
    final board = save.cells
        .mapIndexed(
          (index, cell) => Cell(row: index ~/ save.columns, col: index % save.columns)
            ..mine = cell.mine
            ..state = cell.state,
        )
        .toList();
    return Board._(
      rows: save.rows,
      columns: save.columns,
      board: board,
      mines: board.where((cell) => cell.mine).length,
    );
  }

  SaveMinesweeper toSave() {
    return SaveMinesweeper(
      rows: rows,
      columns: columns,
      cells: _cells.map((cell) => Cell4Save(mine: cell.mine, state: cell.state)).toList(),
    );
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

  void randomMines({required int number, required int clickRow, required int clickCol}) {
    final rand = Random();
    final candidates = List.generate(rows * columns, (index) => (row: index ~/ columns, column: index % columns));
    // Clicked cell and one-cell nearby cells can't be mines.
    for (final (dx, dy) in _nearbyDeltaAndThis) {
      final row = clickRow + dx;
      final column = clickCol + dy;
      candidates.remove((row: row, column: column));
    }
    final maxMines = candidates.length - 1;
    assert(number <= maxMines, "The max mine is $maxMines, but $number is given.");
    number = min<int>(number, maxMines);
    _mines = number;
    var remaining = number;
    while (candidates.isNotEmpty && remaining > 0) {
      assert(_cells.any((cell) => !cell.mine));
      final index = rand.nextInt(candidates.length);
      final (:row, :column) = candidates[index];
      final cell = getCell(row: row, col: column);
      if (!cell.mine) {
        cell.mine = true;
        _addRoundCellMineNum(row: row, col: column); // count as mine created
        remaining--;
        candidates.removeAt(index);
      }
    }
  }

  void _addRoundCellMineNum({required row, required col}) {
    for (final neighbor in iterateAround(cell: getCell(row: row, col: col))) {
      neighbor.minesAround += 1;
    }
  }

  Cell getCell({required row, required col}) {
    return _cells[row * columns + col];
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
      for (var column = 0; column < columns; column++) {
        yield getCell(row: row, col: column);
      }
    }
  }

  bool _isInRange({required int row, required int col}) {
    return 0 <= row && row < rows && 0 <= col && col < columns;
  }
}
