import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'components/gameinfo.dart';
import 'management/gamelogic.dart';
import 'components/gameboard.dart';
import 'management/gametimer.dart';
import 'theme/colors.dart';


class MineSweeper extends ConsumerStatefulWidget {
  const MineSweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MineSweeperState();
}

class _MineSweeperState extends ConsumerState<MineSweeper> {
  late var timer;

  void updateGame(){
    setState(() {
      if (kDebugMode) {
        logger.log(Level.debug, "global refresh!");
      }
    });
  }

  void resetGame(){
    setState(() {
      ref.read(boardManager.notifier).initGame();
      timer = GameTimer(time: 180, refresh: updateGame);
    });
  }

  @override
  void initState(){
    super.initState();
    ref.read(boardManager.notifier).initGame();
    timer = GameTimer(time: 180, refresh: updateGame);
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
            appBar: AppBar(
              title: const Text("MineSweeper"),
              backgroundColor: appbarcolor,
              actions: [
                IconButton(
                  onPressed: (){
                    resetGame();
                    },
                  icon: const Icon(Icons.refresh),
            )
          ],
        ),
        backgroundColor: backgroundcolor,

        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Stack(
                    children: [
                      GameBoard(refresh: updateGame),
                      GameInfo(resetGame: resetGame, time: timer),
                    ])
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // reset button
                Container(
                  width: (boardcols * cellwidth + borderwidth * 2) / 2, height: 22,
                  decoration: BoxDecoration(
                    color: modecolor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(cellroundwidth),
                        bottomLeft: Radius.circular(cellroundwidth))
                  ),
                  child: const Text(
                      "Level: Easy",
                    textAlign: TextAlign.center,
                  )
                ),
                // The Timer
                Container(
                  width: (boardcols * cellwidth + borderwidth * 2) / 2, height: 22,
                  decoration: BoxDecoration(
                      color: timercolor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(cellroundwidth),
                          bottomRight: Radius.circular(cellroundwidth))
                    ),
                  child: Text(
                      "Timer: " + timer.getTime(),
                    textAlign: TextAlign.center,
                  )
                ),
              ],
            ),
          ],
        )
      );
  }
}
