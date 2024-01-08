import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/games/minesweeper/management/mineboard.dart';
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
  final int timerValue = 300;

  void updateGame() {
    setState(() {
      if (kDebugMode) {
        ref.read(boardManager).gameOver ? logger.log(Level.info, "Game Over!") : null;
        ref.read(boardManager).goodGame ? logger.log(Level.info, "Good Game!") : null;
      }
    });
  }

  void resetGame() {
    setState(() {
      ref.read(boardManager.notifier).initGame();
      // ReCreate Timer When Game Reset
      timer = GameTimer(timeStart: timerValue, refresh: updateGame);
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(boardManager.notifier).initGame();
    // Create Timer
    timer = GameTimer(timeStart: timerValue, refresh: updateGame);
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.read(boardManager);
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
        children: [
          [
            ListTile(
              leading: Icon(Icons.videogame_asset),
              title: manager.board.mines >= 0
                  ? RichText(
                textAlign: TextAlign.center,
                      text: TextSpan(style: context.textTheme.titleMedium, children: [
                        TextSpan(
                            text: "${manager.board.countState(state: CellState.flag)}",
                            ),
                        WidgetSpan(child: Icon(Icons.flag, size: 16, color: flagColor)),
                        TextSpan(text: " / "),
                        TextSpan(
                            text: "${manager.board.mines}",
                            ),
                        WidgetSpan(child: Icon(Icons.gps_fixed, size: 16, color: mineColor)),
                      ]),
                    )
                  : "Easy ${manager.board.rows} x ${manager.board.cols}".text(),
            ).expanded(),
            ListTile(
              leading: Icon(Icons.timer),
              // color: timer.checkHalfTime() ? crazyColor :timerColor,
              title: "Timer: ${timer.getTimeLeft()}".text(
                textAlign: TextAlign.center,
              ),
            ).expanded(),
          ].row(maa: MainAxisAlignment.center).padH(8),
          Center(
            child: Stack(
              children: [
                GameBoard(refresh: updateGame, timer: timer),
                GameInfo(resetGame: resetGame, timer: timer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
