import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sit/game/entity/game_state.dart';
import '../manager/timer.dart';
import '../theme.dart';
import '../i18n.dart';
import '../game.dart';

class GameOverModal extends ConsumerWidget {
  const GameOverModal({
    super.key,
    required this.resetGame,
    required this.timer,
  });

  final void Function() resetGame;
  final GameTimer timer;
  final double opacityValue = 0.5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(minesweeperState).state;
    // Lost Game
    if (state == GameState.gameOver) {
      // TODO: don't do this
      timer.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          decoration: BoxDecoration(
            color: gameOverColor,
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              i18n.gameOver,
              style: TextStyle(
                color: gameOverTextColor,
              ),
            ),
          ),
        ),
      );
    }
    // Win Game
    else if (state == GameState.victory) {
      // The Cost Time Should Be Counted Before Timer Stop
      String costTime = timer.getTimeCost();
      timer.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          decoration: BoxDecoration(
            color: goodGameColor,
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              "${i18n.youWin}\n${i18n.timeSpent(costTime)}",
              style: TextStyle(color: goodGameTextColor),
            ),
          ),
        ),
      );
    }
    // Other
    else {
      return const SizedBox.shrink();
    }
  }
}
