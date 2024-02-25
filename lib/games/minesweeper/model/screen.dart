import 'mode.dart';

class Size{
  Size({required this.width, required this.height});
  final double width;
  final double height;
}

class Screen{

  final double screenWidth;
  final double screenHeight;
  final GameMode gameMode;

  const Screen({required this.screenWidth, required this.screenHeight, required this.gameMode});

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
    var wCell = (screenWidth / (gameMode.gameCols + 1)).floorToDouble();
    var hCell = (screenHeight / (gameMode.gameRows + 3)).floorToDouble();
    var cellWidth = wCell > hCell ? hCell : wCell;
    return cellWidth;
  }

  Size getBoardSize() {
    final width = getCellWidth() * gameMode.gameCols + getBorderWidth() * 2;
    final height = getCellWidth() * gameMode.gameRows + getBorderWidth() * 2;
    final boardSize = Size(width: width,height: height);
    return boardSize;
  }
}
