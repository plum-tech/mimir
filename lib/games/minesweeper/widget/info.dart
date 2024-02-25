import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../manager/logic.dart';
import '../manager/timer.dart';
import '../theme/colors.dart';

class GameInfo extends ConsumerWidget {
  const GameInfo({
    super.key,
    required this.resetGame,
    required this.timer,
  });

  final void Function() resetGame;
  final GameTimer timer;
  final double opacityValue = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final borderWidth = screen.getBorderWidth();
    final textSize = screen.getCellWidth();
    // Lost Game
    if (ref.read(boardManager).gameOver) {
      timer.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          width: screen.getBoardSize().width,
          height: screen.getBoardSize().height,
          decoration: BoxDecoration(
              color: gameOverColor,
              borderRadius: BorderRadius.all(
                Radius.circular(borderWidth),
              )),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              "Game Over!\n Click To Restart",
              style: TextStyle(color: gameOverTextColor, fontSize: textSize),
            ),
          ),
        ),
      );
    }
    // Win Game
    else if (ref.read(boardManager).goodGame) {
      // The Cost Time Should Be Counted Before Timer Stop
      String costTime = timer.getTimeCost();
      timer.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          width: screen.getBoardSize().width,
          height: screen.getBoardSize().height,
          decoration: BoxDecoration(
              color: goodGameColor,
              borderRadius: BorderRadius.all(
                Radius.circular(borderWidth),
              )),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              " You Win!\n Time: $costTime \n Click To Play Again",
              style: TextStyle(color: goodGameTextColor, fontSize: textSize),
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
