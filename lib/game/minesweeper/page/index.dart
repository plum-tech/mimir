// thanks to https://github.com/Henry-Sky/minesweeper

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game.dart';

class GameMinesweeperPage extends StatefulWidget {
  final bool newGame;

  const GameMinesweeperPage({
    super.key,
    this.newGame = true,
  });

  @override
  State<StatefulWidget> createState() => _MinesweeperPage();
}

class _MinesweeperPage extends State<GameMinesweeperPage> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GameMinesweeper(newGame: widget.newGame),
    );
  }
}
