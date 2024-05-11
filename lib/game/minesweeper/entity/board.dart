import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/utils/list2d/list2d.dart';
import 'dart:math';
import '../save.dart';
import '../utils.dart';
import 'cell.dart';

part "board.g.dart";

typedef MinesweeperBoardGenerator = void Function(
  CellBoardBuilder board, {
  required int mines,
  required int rowFirstClick,
  required int columnFirstClick,
});

abstract class ICellBoard<TCell extends Cell> {
  int get rows;

  int get columns;

  List2D<TCell> get cells;

  const ICellBoard();

  int indexOf({required int row, required int column}) {
    return row * columns + column;
  }

  TCell getCell({required int row, required int column}) {
    return cells.get(row, column);
  }

  Iterable<TCell> iterateAround({required int row, required int column}) sync* {
    for (final (dx, dy) in CellBoard.nearbyDelta) {
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
  static const nearbyDelta = [(-1, 1), (0, 1), (1, 1), (-1, 0), /*(0,0)*/ (1, 0), (-1, -1), (0, -1), (1, -1)];
  static const nearbyDeltaAndThis = [...nearbyDelta, (0, 0)];
  final int mines;
  @override
  final List2D<Cell> cells;

  @override
  int get rows => cells.rows;

  @override
  int get columns => cells.columns;

  const CellBoard({
    required this.mines,
    required this.cells,
  });

  const CellBoard.byDefault()
      : mines = 0,
        cells = const List2D();

  factory CellBoard.empty({
    required int rows,
    required int columns,
  }) {
    final builder = CellBoardBuilder.generate(rows: rows, columns: columns);
    return builder.build();
  }

  factory CellBoard.withMines({
    required int rows,
    required int columns,
    required int mines,
    required int rowExclude,
    required int columnExclude,
  }) {
    final builder = CellBoardBuilder.generate(rows: rows, columns: columns);
    builder.randomMines(mines: mines, rowFirstClick: rowExclude, columnFirstClick: columnExclude);
    return builder.build();
  }

  factory CellBoard.fromSave(SaveMinesweeper save) {
    final cells = save.cells.mapIndexed(
      (row, column, index, cell) => CellBuilder(row: row, column: column)
        ..mine = cell.mine
        ..state = cell.state,
    );
    final builder = CellBoardBuilder(
      cells: cells,
    );
    builder.updateCells();
    return builder.build();
  }

  List2D<Cell4Save> toSave() {
    return cells.map((cell) => Cell4Save(mine: cell.mine, state: cell.state));
  }

  CellBoard changeCell({required row, required column, required state}) {
    final newCells = List2D.of(cells);
    newCells.set(row, column, cells.get(row, column).copyWith(state: state));
    return copyWith(cells: newCells);
  }

  Map<String, dynamic> toJson() => _$CellBoardToJson(this);

  factory CellBoard.fromJson(Map<String, dynamic> json) => _$CellBoardFromJson(json);
}

class CellBuilder implements Cell {
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

  CellBuilder({
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

class CellBoardBuilder extends ICellBoard<CellBuilder> {
  @override
  late final List2D<CellBuilder> cells;
  int mines = 0;

  @override
  int get rows => cells.rows;

  @override
  int get columns => cells.columns;

  CellBoardBuilder.generate({
    required int rows,
    required int columns,
  })  : assert(rows > 0),
        assert(columns > 0),
        cells = List2D.generate(
          rows,
          columns,
          (row, column, index) => CellBuilder(
            row: row,
            column: column,
          ),
        );

  CellBoardBuilder({
    required this.cells,
  });

  void updateCells() {
    for (final cell in cells) {
      cell.minesAround = 0;
    }
    for (final cell in cells) {
      if (cell.mine) {
        _addRoundCellMineNum(row: cell.row, column: cell.column);
      }
    }
    _countMines();
  }

  void _addRoundCellMineNum({required row, required column}) {
    for (final neighbor in iterateAround(row: row, column: column)) {
      neighbor.minesAround += 1;
    }
  }

  void _countMines() {
    mines = cells.where((cell) => cell.mine).length;
  }

  void generate({
    MinesweeperBoardGenerator generator = randomGenerateMines,
    required int mines,
    required int rowFirstClick,
    required int columnFirstClick,
  }) {
    generator(
      this,
      mines: mines,
      rowFirstClick: rowFirstClick,
      columnFirstClick: columnFirstClick,
    );
  }

  void randomMines({
    required int mines,
    required int rowFirstClick,
    required int columnFirstClick,
  }) {
    final rand = Random();
    final candidates = List.generate(rows * columns, (index) => (row: index ~/ columns, column: index % columns));
    // Clicked cell and one-cell nearby cells can't be mines.
    for (final (dx, dy) in CellBoard.nearbyDeltaAndThis) {
      final row = rowFirstClick + dx;
      final column = columnFirstClick + dy;
      candidates.remove((row: row, column: column));
    }
    final maxMines = candidates.length - 1;
    assert(mines <= maxMines, "The max mine is $maxMines, but $mines is given.");
    var remaining = min<int>(mines, maxMines);
    this.mines = remaining;
    while (candidates.isNotEmpty && remaining > 0) {
      final index = rand.nextInt(candidates.length);
      final (:row, :column) = candidates[index];
      final cell = getCell(row: row, column: column);
      if (!cell.mine) {
        cell.mine = true;
        // count as mine created
        for (final neighbor in iterateAround(row: row, column: column)) {
          neighbor.minesAround += 1;
        }
        remaining--;
        candidates.removeAt(index);
      }
    }
  }

  CellBoard build() {
    return CellBoard(
      mines: mines,
      cells: cells.map((e) => e.build()),
    );
  }
}
