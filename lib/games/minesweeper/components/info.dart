import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/gamelogic.dart';
import '../management/gametimer.dart';
import '../theme/colors.dart';

class GameInfo extends ConsumerWidget{
  const GameInfo({super.key, required this.resetGame, required this.timer});
  final void Function() resetGame;
  final GameTimer timer;
  final double opacityValue = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Time Over
    if(timer.getTimerValue() == 0){
      ref.read(boardManager).gameOver = true;
    }
    // Lost Game
    if(ref.read(boardManager).gameOver){
      timer.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          width: boardWidth,
          height: boardHeight,
          decoration: BoxDecoration(
              color: gameOverColor,
              borderRadius: const BorderRadius.all(
                  Radius.circular(borderWidth),
              )
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
              },
            child: Text(
              "Game Over!\n Click To Restart",
              style: TextStyle(
                  color: gameOverTextColor,
                  fontSize: 40),
            ),
          ),
        ),
      );
    }
    // Win Game
    else if(ref.read(boardManager).goodGame){
      // The Cost Time Should Be Counted Before Timer Stop
      String costTime = timer.getTimeCost();
      timer.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          width: boardWidth,
          height: boardHeight,
          decoration: BoxDecoration(
            color: goodGameColor,
            borderRadius: const BorderRadius.all(
                Radius.circular(borderWidth),
            )
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              " You Win!\n Time: $costTime \n Click To Replay",
              style: TextStyle(
                  color: goodGameTextColor,
                  fontSize: 40
              ),
            ),
          ),
        ),
      );
    }
    // Other
    else{
      return const SizedBox.shrink();
    }
  }
}
