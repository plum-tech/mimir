import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/minesweeper/page/game.dart';
import '../theme.dart';
import '../i18n.dart';

class GameStateModal extends ConsumerWidget {
  final void Function() resetGame;

  const GameStateModal({
    super.key,
    required this.resetGame,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      child: InkWell(
        onTap: () {
          resetGame();
        },
        child: Container(
          decoration: BoxDecoration(
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
    final playTime = ref.watch(minesweeperState.select((state) => state.playtime));
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: goodGameColor.withOpacity(0.5),
        ),
        child: MaterialButton(
          onPressed: () {
            resetGame();
          },
          child: Text(
            "${i18n.youWin}\n${i18n.timeSpent(playTime.getTimeCost())}",
            style: const TextStyle(
              fontSize: 64.0,
            ),
          ),
        ),
      ),
    );
  }
}
