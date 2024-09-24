import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/minesweeper/page/game.dart';
import '../theme.dart';
import '../i18n.dart';

class GameOverModal extends ConsumerWidget {
  final void Function() resetGame;

  const GameOverModal({
    super.key,
    required this.resetGame,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          resetGame();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: gameOverColor.withOpacity(0.5),
          ),
          child: Text(
            i18n.gameOver,
            style: const TextStyle(
              fontSize: 64.0,
            ),
          ).center(),
        ),
      ),
    );
  }
}

class VictoryModal extends ConsumerWidget {
  final void Function() resetGame;

  const VictoryModal({
    super.key,
    required this.resetGame,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playTime = ref.watch(stateMinesweeper.select((state) => state.playtime));
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: victoryColor.withOpacity(0.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            resetGame();
          },
          child: Text(
            "${i18n.youWin}\n${i18n.timeSpent(i18n.formatPlaytime(playTime))}",
            style: const TextStyle(
              fontSize: 64.0,
            ),
          ).center(),
        ),
      ),
    );
  }
}
