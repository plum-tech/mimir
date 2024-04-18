import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math';
import 'cell.dart';

part "board.g.dart";

const _nearbyDelta = [(-1, 1), (0, 1), (1, 1), (-1, 0), /*(0,0)*/ (1, 0), (-1, -1), (0, -1), (1, -1)];

abstract class ICellBoard<TCell extends Cell> {
  int get rows;

  int get columns;

  List<TCell> get cells;

  const ICellBoard();

  int indexOf({required int row, required int column}) {
    return row * columns + column;
  }

  TCell getCell({required int row, required int column}) {
    return cells[indexOf(row: row, column: column)];
  }

  Iterable<TCell> iterateAround({required int row, required int column}) sync* {
    for (final (dx, dy) in _nearbyDelta) {
      final nearbyRow = row + dx;
      final nearbyCol = column + dy;
      if (inRange(row: nearbyRow, col: nearbyCol)) {
        yield getCell(row: nearbyRow, column: nearbyCol);
      }
    }
  }

  Iterable<TCell> iterateAllCells() sync* {
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        yield getCell(row: row, column: column);
      }
    }
  }

  bool inRange({required int row, required int col}) {
    return 0 <= row && row < rows && 0 <= col && col < columns;
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

  int countAroundByState({required Cell cell, required state}) {
    var count = 0;
    for (final cell in iterateAround(row: cell.row, column: cell.column)) {
      if (cell.state == state) {
        count += 1;
      }
    }
    return count;
  }

  int countAroundMines({required Cell cell}) {
    var count = 0;
    for (final cell in iterateAround(row: cell.row, column: cell.column)) {
      if (cell.mine) {
        count += 1;
      }
    }
    return count;
  }
}

@JsonSerializable()
@CopyWith(skipFields: true)
class CellBoard extends ICellBoard<Cell> {
  final int mines;
  @override
  final int rows;
  @override
  final int columns;
  @override
  final List<Cell> cells;

  const CellBoard({
    required this.mines,
    required this.rows,
    required this.columns,
    required this.cells,
  });

  factory CellBoard.empty({
    required int rows,
    required int columns,
  }) {
    final builder = _CellBoardBuilder(rows: rows, columns: columns);
    return builder.build();
  }

  factory CellBoard.withMines({
    required int rows,
    required int columns,
    required int mines,
    required int rowExclude,
    required int columnExclude,
  }) {
    final builder = _CellBoardBuilder(rows: rows, columns: columns);
    builder.randomMines(mines: mines, rowExclude: rowExclude, columnExclude: columnExclude);
    return builder.build();
  }

  CellBoard changeCell({required row, required column, required state}) {
    final newCells = List.of(cells);
    final index = indexOf(row: row, column: column);
    newCells[index] = cells[index].copyWith(state: state);
    return copyWith(cells: newCells);
  }

  Map<String, dynamic> toJson() => _$CellBoardToJson(this);

  factory CellBoard.fromJson(Map<String, dynamic> json) => _$CellBoardFromJson(json);
}

class _CellBuilder implements Cell {
  @override
  final int row;
  @override
  final int column;
  @override
  var mine = false;
  @override
  var state = CellState.covered;
  @override
  var minesAround = 0;

  _CellBuilder({
    required this.row,
    required this.column,
  });

  Cell build() {
    return Cell(
      row: row,
      column: column,
      minesAround: minesAround,
      state: state,
      mine: mine,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class _CellBoardBuilder extends ICellBoard<_CellBuilder> {
  @override
  late final List<_CellBuilder> cells;
  @override
  final int columns;
  @override
  final int rows;
  int mines = 0;

  _CellBoardBuilder({
    required this.rows,
    required this.columns,
    List<_CellBuilder>? cells,
  })  : assert(rows > 0),
        assert(columns > 0),
        assert(cells == null || cells.length == rows * columns) {
    this.cells = cells ??
        List.generate(
          rows * columns,
          (index) => _CellBuilder(
            row: index ~/ columns,
            column: index % columns,
          ),
        );
  }

  void addRoundCellMineNum({required row, required column}) {
    for (final neighbor in iterateAround(row: row, column: column)) {
      neighbor.minesAround += 1;
    }
  }

  void countMines() {
    mines = cells.where((cell) => cell.mine).length;
  }

  void randomMines({
    required mines,
    required rowExclude,
    required columnExclude,
  }) {
    this.mines = mines;
    int beginSafeRow = rowExclude - 1 < 0 ? 0 : rowExclude - 1;
    int endSafeRow = rowExclude + 1 >= rows ? rows - 1 : rowExclude + 1;
    int beginSafeCol = columnExclude - 1 < 0 ? 0 : columnExclude - 1;
    int endSafeCol = columnExclude + 1 >= columns ? columns - 1 : columnExclude + 1;
    var cnt = 0;
    while (cnt < mines) {
      var value = Random().nextInt(columns * rows);
      var col = value % columns;
      var row = (value / columns).floor();
      final cell = cells[row * columns + col];
      if (!cell.mine && !((row >= beginSafeRow && row <= endSafeRow) && (col >= beginSafeCol && col <= endSafeCol))) {
        cell.mine = true;
        for (final neighbor in iterateAround(row: row, column: col)) {
          neighbor.minesAround += 1;
        }
        addRoundCellMineNum(row: row, column: col); // count as mine created
        cnt += 1;
      }
    }
  }

  CellBoard build() {
    return CellBoard(
      mines: mines,
      rows: rows,
      columns: columns,
      cells: cells.map((e) => e.build()).toList(),
    );
  }
}
