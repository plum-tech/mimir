import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/gamelogic.dart';
import '../management/gametimer.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';

class GameInfo extends ConsumerWidget{
  const GameInfo({super.key, required this.resetGame, required this.time});
  final Function resetGame;
  final GameTimer time;
  final opacityvalue = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Time Over
    if(time.getTime() == "00:00"){
      ref.read(boardManager).gameover = true;
    }
    // Lost Game
    if(ref.read(boardManager).gameover){
      time.stopTimer();
      return Opacity(
        opacity: opacityvalue,
        child: Container(
          width: cellwidth * boardcols + borderwidth * 2 ,
          height: cellwidth * boardrows + borderwidth * 2,
          decoration: BoxDecoration(
              color: gameovercolor,
              borderRadius: const BorderRadius.all(Radius.circular(borderwidth))
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
              },
            child: Text(
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
      return Opacity(
        opacity: opacityvalue,
        child: Container(
          width: cellwidth * boardcols + borderwidth * 2 ,
          height: cellwidth * boardrows + borderwidth * 2,
          decoration: BoxDecoration(
            color: goodgamecolor,
            borderRadius: const BorderRadius.all(Radius.circular(borderwidth))
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              " You Win!\n Time: $wintime \n Click To Replay",
              style: TextStyle(
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
