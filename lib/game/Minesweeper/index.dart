// thanks to https://github.com/Henry-Sky/MinesSweeper

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game.dart';

class MinesweeperPage extends StatefulWidget {
  const MinesweeperPage({super.key});

  @override
  State<StatefulWidget> createState() => _MinesweeperPage();
}


class _MinesweeperPage extends State<MinesweeperPage> {

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MineSweeper()
    );
  }
}
