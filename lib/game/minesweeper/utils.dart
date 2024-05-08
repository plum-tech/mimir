import 'dart:math';

import 'entity/board.dart';

Iterable<int> generateSymmetricRange(int start, int end) sync* {
  start = start.abs();
  end = end.abs();
  for (var i = -end + 1; i < -start + 1; i++) {
    yield i;
  }
  if (start == 0) {
    start = 1;
  }
  for (var i = start; i < end; i++) {
    yield i;
  }
}

Iterable<(int, int)> generateCoord(int extensionStep, {int startWith = 0}) sync* {
  for (final x in generateSymmetricRange(startWith, extensionStep)) {
    for (final y in generateSymmetricRange(startWith, extensionStep)) {
      yield (x, y);
    }
  }
}

// TODO: generating a game without guesswork
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
  // for (final (dx, dy) in generateCoord(5, startWith: 2)) {
  //   final row = rowFirstClick + dx;
  //   final column = columnFirstClick + dy;
  //   if (rand.nextBool()) {
  //     candidates.remove((row: row, column: column));
  //   }
  // }
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
