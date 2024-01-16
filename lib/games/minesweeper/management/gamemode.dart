import 'gamelogic.dart';
import 'gametimer.dart';

enum Mode{
  easy,
  normal,
  hard,
}

class GameMode{
  late int gameRows;
  late int gameCols;
  late final int gameMines;

  final Mode mode;
  GameMode({required this.mode}) {
    switch(mode){
      case Mode.easy:
        gameRows = 15;
        gameCols = 8;
        gameMines = 18;
      case Mode.normal:
        gameRows = 15;
        gameCols = 8;
        gameMines = 18;
      case Mode.hard:
        gameRows = 15;
        gameCols = 8;
        gameMines = 18;
      default:
        gameRows = 15;
        gameCols = 8;
        gameMines = 18;
    }
  }

}
