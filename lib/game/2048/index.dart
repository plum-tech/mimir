// thanks to https://github.com/angjelkom/flutter_2048
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game.dart';

class Game2048Page extends StatefulWidget {
  const Game2048Page({super.key});

  @override
  State<Game2048Page> createState() => _Game2048PageState();
}

class _Game2048PageState extends State<Game2048Page> {
  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: Game2048(),
    );
  }
}
