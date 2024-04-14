import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sit/game/minesweeper/entity/screen.dart';

import 'board.dart';
import 'mode.dart';

part "state.g.dart";

@CopyWith(skipFields: true)
class GameStates {
  final bool gameOver;
  final bool goodGame;
  final GameMode mode;
  final Screen screen;
  final Board board;

  const GameStates({
    required this.gameOver,
    required this.goodGame,
    required this.mode,
    required this.screen,
    required this.board,
  });
}
