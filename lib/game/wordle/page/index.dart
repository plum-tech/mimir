import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sit/game/wordle/entity/word_set.dart';
import '../event_bus.dart';
import '../page/loading.dart';
import '../widget/selection_group.dart';

class GameWordlePage extends StatefulWidget {
  const GameWordlePage({super.key});

  @override
  State<GameWordlePage> createState() => _GameWordlePageState();
}

class _GameWordlePageState extends State<GameWordlePage> {

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      dicName: WordleWordSet.all.name,
      wordLen: 5,
      maxChances: 6,
      gameMode: 0,
    );
  }
}
