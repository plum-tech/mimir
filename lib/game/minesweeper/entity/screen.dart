import 'dart:ui';

class Screen {
  final double width;
  final double height;
  final int gameRows;
  final int gameColumns;

  const Screen({
    required this.width,
    required this.height,
    required this.gameRows,
    required this.gameColumns,
  });

  double getCellWidth() {
    var wCell = (width / (gameColumns + 1)).floorToDouble();
    var hCell = (height / (gameRows + 3)).floorToDouble();
    var cellWidth = wCell > hCell ? hCell : wCell;
    return cellWidth;
  }

  Size getBoardSize() {
    final width = getCellWidth() * gameColumns;
    final height = getCellWidth() * gameRows;
    final boardSize = Size(width, height);
    return boardSize;
  }
}
