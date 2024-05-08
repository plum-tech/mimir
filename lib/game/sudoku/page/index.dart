// Thanks to "https://github.com/VarunS2002/Flutter-Sudoku"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game.dart';

class GameSudokuPage extends StatelessWidget {
  const GameSudokuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: GameSudoku(),
    );
  }
}
