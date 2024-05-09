import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/game/ability/ability.dart';
import 'package:sit/game/ability/autosave.dart';
import 'package:sit/game/ability/timer.dart';
import 'package:sit/game/entity/game_state.dart';
import 'package:sit/game/minesweeper/save.dart';

import '../entity/mode.dart';
import '../entity/screen.dart';
import '../entity/state.dart';
import '../manager/logic.dart';
import '../../entity/timer.dart';
import '../widget/board.dart';
import '../widget/hud.dart';
import '../widget/modal.dart';
import '../i18n.dart';

final minesweeperState = StateNotifierProvider.autoDispose<GameLogic, GameStateMinesweeper>((ref) {
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

class _MinesweeperState extends ConsumerState<GameMinesweeper> with WidgetsBindingObserver, GameAbilityMixin {
  late TimerAbility timerAbility;

  GameTimer get timer => timerAbility.timer;

  @override
  List<GameAbility> createAbility() => [
        AutoSaveAbility(onSave: onSave),
        timerAbility = TimerAbility(),
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      timer.addListener((state) {
        ref.read(minesweeperState.notifier).playtime = state;
      });
      if (!widget.newGame) {
        final save = SaveMinesweeper.storage.load();
        if (save != null) {
          ref.read(minesweeperState.notifier).fromSave(save);
          timer.state = ref.read(minesweeperState).playtime;
        } else {
          ref.read(minesweeperState.notifier).initGame(gameMode: GameMode.easy);
          timer.state = ref.read(minesweeperState).playtime;
        }
      }
    });
  }

  void onSave() {
    ref.read(minesweeperState.notifier).save();
  }

  void resetGame() {
    timer.reset();
    final gameMode = ref.watch(minesweeperState.select((state) => state.mode));
    ref.read(minesweeperState.notifier).initGame(gameMode: gameMode);
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
    ref.listen(minesweeperState, onGameStateChange);
    final screenSize = MediaQuery.of(context).size;
    final screen = Screen(
      height: screenSize.height,
      width: screenSize.width,
      gameRows: state.rows,
      gameColumns: state.columns,
    );
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
          const GameHud().padH(8),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Center(
              child: Stack(
                children: [
                  GameBoard(screen: screen),
                  if (state.state == GameState.gameOver)
                    GameStateModal(
                      resetGame: resetGame,
                    )
                  else if (state.state == GameState.victory)
                    VictoryModal(
                      resetGame: resetGame,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
