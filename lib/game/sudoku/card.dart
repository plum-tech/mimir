import 'package:flutter/material.dart';
import 'save.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';

class GameAppCardSudoku extends StatefulWidget {
  const GameAppCardSudoku({super.key});

  @override
  State<GameAppCardSudoku> createState() => _GameAppCardSudokuState();
}

class _GameAppCardSudokuState extends State<GameAppCardSudoku> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/sudoku",
      storage: SaveSudoku.storage,
    );
  }
}
