import 'gamelogic.dart';

class Size{
  Size({required this.width, required this.height});
  final double width;
  final double height;
}

class Screen{
  Screen({required this.screenWidth, required this.screenHeight});
  final double screenWidth;
  final double screenHeight;

  double getBorderWidth() {
    return (getCellWidth() / 8).floorToDouble();
  }

  double getBoardRadius() {
    return (getCellWidth() / 5).floorToDouble();
  }

  double getInfoHeight() {
    return (screenHeight - getBoardSize().height) * 0.2;
  }

  double getCellWidth() {
    var wCell = (screenWidth / (boardCols + 1)).floorToDouble();
    var hCell = (screenHeight / (boardRows + 3)).floorToDouble();
    var cellWidth = wCell > hCell ? hCell : wCell;
    return cellWidth;
  }

  Size getBoardSize() {
    final _width = getCellWidth() * boardCols + getBorderWidth() * 2;
    final _height = getCellWidth() * boardRows + getBorderWidth() * 2;
    final boardSize = Size(width: _width,height: _height);
    return boardSize;
  }
}
