// Thanks to "https://github.com/VarunS2002/Flutter-Sudoku",
// and "https://github.com/einsitang/sudoku-flutter"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game.dart';

class GameSudokuPage extends StatelessWidget {
  final bool newGame;

  const GameSudokuPage({
    super.key,
    this.newGame = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GameSudoku(
        newGame: newGame,
      ),
    );
  }
}
