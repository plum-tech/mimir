import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/game.dart';
import '../theme.dart';
import '../i18n.dart';
import 'button.dart';

class GameOverModal extends ConsumerWidget {
  const GameOverModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(state2048);
    return Container(
      color: overlayColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            board.won ? i18n.youWin : i18n.gameOver,
            style: const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 64.0),
          ),
          ButtonWidget(
            text: board.won ? i18n.newGame : i18n.tryAgain,
            onPressed: () {
              ref.read(state2048.notifier).newGame();
            },
          )
        ],
      ),
    );
  }
}
