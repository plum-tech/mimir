import 'dart:math';

import 'entity/board.dart';

void randomGenerateMines(
  CellBoardBuilder board, {
  required int mines,
  required int rowFirstClick,
  required int columnFirstClick,
}) {
  final rand = Random();
  final candidates = List.generate(
      board.rows * board.columns, (index) => (row: index ~/ board.columns, column: index % board.columns));
  // Clicked cell and one-cell nearby cells can't be mines.
  for (final (dx, dy) in CellBoard.nearbyDeltaAndThis) {
    final row = rowFirstClick + dx;
    final column = columnFirstClick + dy;
    candidates.remove((row: row, column: column));
  }
  final maxMines = candidates.length - 1;
  assert(mines <= maxMines, "The max mine is $maxMines, but $mines is given.");
  var remaining = min<int>(mines, maxMines);
  board.mines = remaining;
  while (candidates.isNotEmpty && remaining > 0) {
    final index = rand.nextInt(candidates.length);
    final (:row, :column) = candidates[index];
    final cell = board.getCell(row: row, column: column);
    if (!cell.mine) {
      cell.mine = true;
      // count as mine created
      for (final neighbor in board.iterateAround(row: row, column: column)) {
        neighbor.minesAround += 1;
      }
      remaining--;
      candidates.removeAt(index);
    }
  }
}
