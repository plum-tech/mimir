import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/gamelogic.dart';
import '../management/gametimer.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';

class GameInfo extends ConsumerWidget{
  const GameInfo({super.key, required this.resetGame, required this.time});
  final Function resetGame;
  final GameTimer time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Time Over
    if(time.getTime() == "00:00"){
      ref.read(boardManager).gameover = true;
    }
    // Lost Game
    if(ref.read(boardManager).gameover){
      time.stopTimer();
      return Opacity(opacity: 0.5,
        child: Container(
          width: cellwidth * boardcols + borderwidth * 2 ,
          height: cellwidth * boardrows + borderwidth * 2,
          color: gameovercolor,
          child: MaterialButton(onPressed: () {
            resetGame();
          },
            child: const Text(
              "Game Over!\n Click To Restart",
              style: TextStyle(
                  color: gameovertextcolor,
                  fontSize: 40),
            ),
          ),
        ),
      );
    }
    // Win Game
    else if(ref.read(boardManager).goodgame){
      var wintime = time.getWintime();
      time.stopTimer();
      return Opacity(opacity: 0.5,
        child: Container(
          width: cellwidth * boardcols + borderwidth * 2 ,
          height: cellwidth * boardrows + borderwidth * 2,
          color: goodgamecolor,
          child: MaterialButton(onPressed: () {
            resetGame();
          },
            child: Text(
              " You Win!\n Time: $wintime \n Click To Replay",
              style: const TextStyle(
                  color: goodgametextcolor,
                  fontSize: 40),
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
