// thanks to https://github.com/Henry-Sky/minesweeper

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game.dart';

class GameMinesweeperPage extends StatelessWidget {
  final bool newGame;

  const GameMinesweeperPage({
    super.key,
    this.newGame = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GameMinesweeper(
        newGame: newGame,
      ),
    );
  }
}
