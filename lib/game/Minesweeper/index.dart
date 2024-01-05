// thanks to https://github.com/Henry-Sky/MinesSweeper

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'game.dart';

class MinesweeperPage extends StatefulWidget {
  const MinesweeperPage({super.key});

  @override
  State<StatefulWidget> createState() => _MinesweeperPage();
}


class _MinesweeperPage extends State<MinesweeperPage> {

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Scaffold(
        appBar: AppBar(
          title: "Minesweeper".text(),
        ),
        body: const MineSweeper(),
      ),
    );
  }
}
