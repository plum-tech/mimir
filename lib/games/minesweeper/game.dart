import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import 'components/info.dart';
import 'management/gamelogic.dart';
import 'components/board.dart';
import "package:flutter/foundation.dart";
import 'management/gametimer.dart';
import 'theme/colors.dart';

class GameMinesweeper extends ConsumerStatefulWidget {
  const GameMinesweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinesweeperState();
}

class _MinesweeperState extends ConsumerState<GameMinesweeper> {
  late GameTimer timer;
  final int timerValue = 60;

  void updateGame() {
    if (!timer.timerStart && !ref.read(boardManager.notifier).firstClick){
      timer.startTimer();
    }
    setState(() {
      if (kDebugMode) {
        ref.read(boardManager).gameOver
            ? logger.log(Level.info, "Game Over!")
            : null;
        ref.read(boardManager).goodGame
            ? logger.log(Level.info, "Good Game!")
            : null;
      }
    });
  }

  void resetGame() {
    timer.stopTimer();
    timer = GameTimer(cntStart: timerValue, refresh: updateGame);
    setState(() {
      ref.read(boardManager.notifier).initGame();
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(boardManager.notifier).initGame();
    timer = GameTimer(cntStart: timerValue, refresh: updateGame);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    ref.read(boardManager.notifier).initScreen(
        width: screenSize.width,
        height: screenSize.height
    );
    final screen = ref.read(boardManager).screen;

    if (kDebugMode){
      logger.log(Level.info, "ScreenSize: w:${screenSize.width},h:${screenSize.height}");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minesweeper",
        ),
        actions: [
          IconButton(
            onPressed: () {
              resetGame();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          )
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screen.getBoardSize().width / 2,
                    height: screen.getInfoHeight(),
                    decoration: BoxDecoration(
                      color: modeColor,
                    ),
                    child: const Text(
                      "Mode: Easy",
                    ),
                  ),
                  Container(
                    width: screen.getBoardSize().width / 2,
                    height: screen.getInfoHeight(),
                    decoration: BoxDecoration(
                      color: timerColor,
                    ),
                    child: Text(
                        "Time: ${timer.getTimeLeft()}",
                    ),
                  ),
                ]),

              Center(
                child: Stack(
                  children: [
                    GameBoard(refresh: updateGame, timer: timer),
                    GameInfo(resetGame: resetGame, timer: timer),
                  ],
                ),
              ),
          ]
      ),
    );
  }
}
