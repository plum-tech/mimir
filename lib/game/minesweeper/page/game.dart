import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/game/entity/game_state.dart';
import 'package:sit/game/minesweeper/save.dart';
import 'entity/cell.dart';
import 'entity/mode.dart';
import 'entity/screen.dart';
import 'entity/state.dart';
import 'widget/info.dart';
import 'manager/logic.dart';
import 'widget/board.dart';
import "package:flutter/foundation.dart";
import 'manager/timer.dart';
import 'theme.dart';
import 'i18n.dart';

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
    timer = GameTimer(refresh: updateGame);
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

  void updateGame() {
    if (!timer.timerStart && ref.read(minesweeperState).state == GameState.running) {
      timer.startTimer();
    }
    if (!context.mounted) return;
    setState(() {
      if (kDebugMode) {
        // ref.read(boardManager).gameOver ? logger.log(Level.info, "Game Over!") : null;
        // ref.read(boardManager).goodGame ? logger.log(Level.info, "Good Game!") : null;
      }
    });
  }

  void resetGame() {
    timer.stopTimer();
    timer = GameTimer(refresh: updateGame);
    ref.read(minesweeperState.notifier).initGame(gameMode: GameMode.easy);
    updateGame();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(minesweeperState);
    // Get Your Screen Size
    final screenSize = MediaQuery.of(context).size;
    final mode = ref.watch(boardManager).mode;
    initScreen(screenSize: screenSize, gameMode: mode);
    // Build UI From Screen Size

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
          GameHud(
            mode: state.mode,
            timer: timer,
          ),
          Center(
            child: Stack(
              children: [
                GameBoard(screen: screen, refresh: updateGame, timer: timer),
                GameOverModal(resetGame: resetGame, timer: timer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
