// Thanks to "https://github.com/welchi/flutter_suika_game"
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import 'ui/main_game.dart';

class GameSuikaPage extends StatefulWidget {
  const GameSuikaPage({super.key});

  @override
  State<GameSuikaPage> createState() => _SuikaGameState();
}

class _SuikaGameState extends State<GameSuikaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Suika Game".text(),
      ),
      body: GameWidget(
        game: SuikaGame(),
      ),
    );
  }
}
