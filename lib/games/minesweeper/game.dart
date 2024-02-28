import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import 'model/cell.dart';
import 'model/mode.dart';
import 'widget/info.dart';
import 'manager/logic.dart';
import 'widget/board.dart';
import "package:flutter/foundation.dart";
import 'manager/timer.dart';
import 'theme/colors.dart';
import 'i18n.dart';

class GameMinesweeper extends ConsumerStatefulWidget {
  const GameMinesweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinesweeperState();
}

class _MinesweeperState extends ConsumerState<GameMinesweeper> {
  late GameTimer timer;
  late GameMode mode;

  void updateGame() {
    if (!timer.timerStart && !ref.read(boardManager.notifier).firstClick) {
      timer.startTimer();
    }
    if (!context.mounted) return;
    setState(() {
      if (kDebugMode) {
        ref.read(boardManager).gameOver ? logger.log(Level.info, "Game Over!") : null;
        ref.read(boardManager).goodGame ? logger.log(Level.info, "Good Game!") : null;
      }
    });
  }

  void resetGame({gameMode = GameMode.easy}) {
    timer.stopTimer();
    mode = gameMode;
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
    mode = GameMode.easy;
    timer = GameTimer(refresh: updateGame);
    ref.read(boardManager.notifier).initGame(gameMode: mode);
    if (kDebugMode) {
      logger.log(Level.info, "GameState Init Finished");
    }
  }

  @override
  void dispose() {
    timer.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get Your Screen Size
    final screenSize = MediaQuery.of(context).size;
    initScreen(screenSize: screenSize, gameMode: mode);
    // Build UI From Screen Size
    final screen = ref.read(boardManager).screen;
    final boardRadius = screen.getBoardRadius();
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: i18n.title.text(),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screen.getBoardSize().width / 2,
                height: screen.getInfoHeight(),
                decoration: BoxDecoration(
                    color: context.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(boardRadius), bottomLeft: Radius.circular(boardRadius))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: screen.getBorderWidth(),
                    ),
                    const Icon(Icons.videogame_asset_outlined),
                    SizedBox(
                      width: screen.getBorderWidth(),
                    ),
                    ref.read(boardManager).board.mines == -1
                        ? Text(
                            mode.l10n(),
                            style: textTheme.bodyLarge,
                          )
                        : MinesAndFlags(
                            flags: ref.read(boardManager).board.countAllByState(state: CellState.flag),
                            mines: ref.read(boardManager).board.countMines(),
                          ),
                  ],
                ),
              ),
              Container(
                  width: screen.getBoardSize().width / 2,
                  height: screen.getInfoHeight(),
                  decoration: BoxDecoration(
                      color: context.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(boardRadius),
                        bottomRight: Radius.circular(boardRadius),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.alarm),
                      SizedBox(
                        width: screen.getBorderWidth(),
                      ),
                      Text(
                        timer.getTimeCost(),
                        style: textTheme.bodyLarge,
                      ),
                      SizedBox(
                        width: screen.getBorderWidth(),
                      ),
                    ],
                  )),
            ],
          ),
          Center(
            child: Stack(
              children: [
                GameBoard(refresh: updateGame, timer: timer),
                GameOverModal(resetGame: resetGame, timer: timer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MinesAndFlags extends StatelessWidget {
  final int flags;
  final int mines;

  const MinesAndFlags({
    super.key,
    required this.flags,
    required this.mines,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Row(
      children: [
        Text(
          " $flags ",
          style: textTheme.bodyLarge,
        ),
        const Icon(
          Icons.flag_outlined,
          color: flagColor,
        ),
        Text(
          "/ $mines ",
          style: textTheme.bodyLarge,
        ),
        const Icon(
          Icons.gps_fixed,
          color: mineColor,
        ),
      ],
    );
  }
}
