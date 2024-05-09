import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/sudoku/entity/state.dart';

import '../entity/mode.dart';
import '../entity/board.dart';

class GameLogic extends StateNotifier<GameStateSudoku> {
  GameLogic([GameStateSudoku? initial]) : super(initial ?? GameStateSudoku.byDefault());

  void initGame({required GameMode gameMode}) {
    final board = SudokuBoard.generate(emptySquares: gameMode.blanks);
    state = GameStateSudoku(mode: gameMode, board: board);
  }

  Future<void> save() async {
    if (state.state.shouldSave) {
    } else {
    }
  }
}
