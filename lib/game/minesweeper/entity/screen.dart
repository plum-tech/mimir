import 'dart:ui';

import 'mode.dart';

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

  double getBorderWidth() {
    return (getCellWidth() / 8).floorToDouble();
  }

  double getBoardRadius() {
    return 12;
  }

  double getInfoHeight() {
    return (height - getBoardSize().height) * 0.2;
  }

  double getCellWidth() {
    var wCell = (width / (gameColumns + 1)).floorToDouble();
    var hCell = (height / (gameRows + 3)).floorToDouble();
    var cellWidth = wCell > hCell ? hCell : wCell;
    return cellWidth;
  }

  Size getBoardSize() {
    final width = getCellWidth() * gameColumns + getBorderWidth() * 2;
    final height = getCellWidth() * gameRows + getBorderWidth() * 2;
    final boardSize = Size(width, height);
    return boardSize;
  }
}
