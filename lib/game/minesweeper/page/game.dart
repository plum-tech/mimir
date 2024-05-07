import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/game/entity/game_state.dart';
import 'package:sit/game/minesweeper/save.dart';
import "package:flutter/foundation.dart";

import '../entity/mode.dart';
import '../entity/screen.dart';
import '../entity/state.dart';
import '../manager/logic.dart';
import '../manager/timer.dart';
import '../widget/board.dart';
import '../widget/hud.dart';
import '../widget/info.dart';
import '../i18n.dart';

final minesweeperState = StateNotifierProvider<GameLogic, GameStateMinesweeper>((ref) {
  if (kDebugMode) {
    logger.log(Level.info, "GameLogic Init Finished");
  }
  return GameLogic();
});

class GameMinesweeper extends ConsumerStatefulWidget {
  final bool newGame;

  const GameMinesweeper({
    super.key,
    this.newGame = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinesweeperState();
}

class _MinesweeperState extends ConsumerState<GameMinesweeper> with WidgetsBindingObserver {
  late GameTimer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    timer = GameTimer();
    Future.delayed(Duration.zero).then((value) {
      if (!widget.newGame) {
        final save = SaveMinesweeper.storage.load();
        if (save != null) {
          // ref.read(boardManager.notifier).fromSave(CellBoard.fromSave(save));
          ref.read(minesweeperState.notifier).initGame(gameMode: GameMode.easy);
        } else {
          ref.read(minesweeperState.notifier).initGame(gameMode: GameMode.easy);
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Save current state when the app becomes inactive
    if (state == AppLifecycleState.inactive) {
      ref.read(minesweeperState.notifier).save();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    super.deactivate();
    ref.read(minesweeperState.notifier).save();
  }

  @override
  void dispose() {
    //Remove the Observer for the Lifecycles of the App
    WidgetsBinding.instance.removeObserver(this);
    timer.stopTimer();
    super.dispose();
  }

  void resetGame() {
    timer.stopTimer();
    timer = GameTimer();
    ref.read(minesweeperState.notifier).initGame(gameMode: GameMode.easy);
  }

  void startTimer() {
    if (!timer.timerStart) {
      timer.startTimer();
    }
  }

  void stopTimer() {
    if (timer.timerStart) {
      timer.stopTimer();
    }
  }

  void onGameStateChange(GameStateMinesweeper? former, GameStateMinesweeper current) {
    switch (current.state) {
      case GameState.running:
        startTimer();
      case GameState.idle:
        stopTimer();
      case GameState.gameOver:
        stopTimer();
      case GameState.victory:
        stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(minesweeperState);
    // Get Your Screen Size
    final screenSize = MediaQuery.of(context).size;
    final mode = ref.watch(minesweeperState).mode;
    final screen = Screen(
      height: screenSize.height,
      width: screenSize.width,
      gameRows: state.rows,
      gameColumns: state.columns,
    );
    ref.listen(minesweeperState, onGameStateChange);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: i18n.title.text(),
        actions: [
          PlatformIconButton(
            onPressed: () {
              resetGame();
            },
            icon: Icon(context.icons.refresh),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GameHud(mode: state.mode, timer: timer),
          Center(
            child: Stack(
              children: [
                GameBoard(screen: screen),
                GameOverModal(resetGame: resetGame, timer: timer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
