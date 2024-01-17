enum CellState {
  covered,
  blank,
  flag,
}

class Cell {
  Cell({
    required this.row,
    required this.col,
  });

  final int row;
  final int col;
  bool mine = false;
  CellState state = CellState.covered;
  int minesAround = 0;
}
