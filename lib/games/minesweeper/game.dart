import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'model/cell.dart';
import 'model/mode.dart';
import 'widget/info.dart';
import 'manager/logic.dart';
import 'widget/board.dart';
import "package:flutter/foundation.dart";
import 'manager/timer.dart';
import 'theme/colors.dart';

class GameMinesweeper extends ConsumerStatefulWidget {
  const GameMinesweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinesweeperState();
}

class _MinesweeperState extends ConsumerState<GameMinesweeper> {
  late GameTimer timer;
  late GameMode mode;

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

  void resetGame({gameMode = Mode.easy}) {
    timer.stopTimer();
    mode = GameMode(mode: gameMode);
    timer = GameTimer(refresh: updateGame);
    ref.read(boardManager.notifier).initGame(gameMode: mode);
    updateGame();
  }

  void initScreen({required screenSize, required gameMode}) {
    // The Appbar Height 56
    ref.read(boardManager.notifier).initScreen(
      width: screenSize.width,
      height: screenSize.height - 56,
      mode: gameMode,
    );
  }

  @override
  void initState() {
    super.initState();
    mode = GameMode(mode: Mode.easy);
    timer = GameTimer(refresh: updateGame);
    ref.read(boardManager.notifier).initGame(gameMode: mode);
    if (kDebugMode){
      logger.log(Level.info, "GameState Init Finished");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get Your Screen Size
    final screenSize = MediaQuery.of(context).size;
    initScreen(screenSize: screenSize, gameMode: mode);
    // Build UI From Screen Size
    final screen = ref.read(boardManager).screen;
    final boardRadius = screen.getBoardRadius();
    final infoFrontSize = screen.getInfoHeight() * 0.5;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(boardRadius),
                          bottomLeft: Radius.circular(boardRadius)
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screen.getBorderWidth(),
                        ),
                        Icon(
                          Icons.videogame_asset_outlined,
                          size: screen.getInfoHeight(),
                        ),
                        SizedBox(
                          width: screen.getBorderWidth(),
                        ),
                        ref.read(boardManager).board.mines == -1
                            ? Text(
                                "Mode: Easy",
                                style: TextStyle(
                                  fontSize: infoFrontSize,
                                ),
                            )
                            : Row(
                              children: [
                                Text(
                                  " ${ref.read(boardManager).board.countAllByState(state: CellState.flag)} ",
                                  style: TextStyle(
                                    fontSize: infoFrontSize,
                                  ),
                                ),
                                Icon(
                                  Icons.flag_outlined,
                                  size: screen.getInfoHeight() * 0.6,
                                  color: flagColor,
                                ),
                                Text(
                                  "/ ${ref.read(boardManager).board.countMines()} ",
                                  style: TextStyle(
                                    fontSize: infoFrontSize,
                                  ),
                                ),
                                Icon(
                                  Icons.gps_fixed,
                                  size: screen.getInfoHeight() * 0.5,
                                  color: mineColor,
                                ),
                              ],
                        ),
                      ],
                    )
                  ),
                  Container(
                    width: screen.getBoardSize().width / 2,
                    height: screen.getInfoHeight(),
                    decoration: BoxDecoration(
                      color: timerColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(boardRadius),
                        bottomRight: Radius.circular(boardRadius),
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.alarm,
                          size: screen.getInfoHeight() * 0.8,
                        ),
                        SizedBox(
                          width: screen.getBorderWidth(),
                        ),
                        Text(
                          "Time: ${timer.getTimeCost()}",
                          style: TextStyle(
                            fontSize: infoFrontSize,
                          ),
                        ),
                        SizedBox(
                          width: screen.getBorderWidth(),
                        ),
                      ],
                    )
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
