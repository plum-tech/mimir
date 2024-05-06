import 'package:json_annotation/json_annotation.dart';

enum CellState {
  @JsonValue(0)
  covered,
  @JsonValue(1)
  blank,
  @JsonValue(2)
  flag;
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
