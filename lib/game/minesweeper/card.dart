import 'package:flutter/material.dart';
import 'save.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';

class GameAppCardMinesweeper extends StatefulWidget {
  const GameAppCardMinesweeper({super.key});

  @override
  State<GameAppCardMinesweeper> createState() => _GameAppCardMinesweeperState();
}

class _GameAppCardMinesweeperState extends State<GameAppCardMinesweeper> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/minesweeper",
      storage: SaveMinesweeper.storage,
    );
  }
}
