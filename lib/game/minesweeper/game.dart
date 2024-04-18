import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/game/minesweeper/save.dart';
import 'entity/board.dart';
import 'entity/cell.dart';
import 'entity/mode.dart';
import 'widget/info.dart';
import 'manager/logic.dart';
import 'widget/board.dart';
import "package:flutter/foundation.dart";
import 'manager/timer.dart';
import 'theme.dart';
import 'i18n.dart';

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
  late GameMode mode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mode = GameMode.easy;
    timer = GameTimer(refresh: updateGame);
    ref.read(boardManager.notifier).initGame(gameMode: mode);
    Future.delayed(Duration.zero).then((value) {
      if (!widget.newGame) {
        final save = SaveMinesweeper.storage.load();
        if (save != null) {
          ref.read(boardManager.notifier).fromSave(CellBoard.fromSave(save));
        } else {
          ref.read(boardManager.notifier).initGame(gameMode: mode);
        }
      }
    });
    if (kDebugMode) {
      logger.log(Level.info, "GameState Init Finished");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Save current state when the app becomes inactive
    if (state == AppLifecycleState.inactive) {
      ref.read(boardManager.notifier).save();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    super.deactivate();
    ref.read(boardManager.notifier).save();
  }

  @override
  void dispose() {
    //Remove the Observer for the Lifecycles of the App
    WidgetsBinding.instance.removeObserver(this);
    timer.stopTimer();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    // Get Your Screen Size
    final screenSize = MediaQuery.of(context).size;
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
            mode: mode,
            timer: timer,
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

class GameHud extends ConsumerWidget {
  final GameTimer timer;
  final GameMode mode;

  const GameHud({
    super.key,
    required this.mode,
    required this.timer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final boardRadius = screen.getBoardRadius();
    final textTheme = context.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screen.getBoardSize().width / 2,
          height: screen.getInfoHeight(),
          decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(boardRadius), bottomLeft: Radius.circular(boardRadius))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.videogame_asset_outlined),
              ref.read(boardManager).board.started
                  ? MinesAndFlags(
                      flags: ref.read(boardManager).board.countAllByState(state: CellState.flag),
                      mines: ref.read(boardManager).board.mines,
                    )
                  : Text(
                      mode.l10n(),
                      style: textTheme.bodyLarge,
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
              Text(
                timer.getTimeCost(),
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
