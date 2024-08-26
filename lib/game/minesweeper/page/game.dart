import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/game/ability/ability.dart';
import 'package:mimir/game/ability/autosave.dart';
import 'package:mimir/game/ability/timer.dart';
import 'package:mimir/game/entity/game_status.dart';
import 'package:mimir/game/minesweeper/settings.dart';
import 'package:mimir/game/widget/party_popper.dart';

import '../entity/screen.dart';
import '../entity/state.dart';
import '../manager/logic.dart';
import '../../entity/timer.dart';
import '../storage.dart';
import '../widget/board.dart';
import '../widget/hud.dart';
import '../widget/modal.dart';
import '../i18n.dart';

final stateMinesweeper = StateNotifierProvider.autoDispose<GameLogic, GameStateMinesweeper>((ref) {
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

class _MinesweeperState extends ConsumerState<GameMinesweeper> with WidgetsBindingObserver, GameWidgetAbilityMixin {
  late TimerWidgetAbility timerAbility;

  GameTimer get timer => timerAbility.timer;

  @override
  List<GameWidgetAbility> createAbility() => [
        AutoSaveWidgetAbility(onSave: onSave),
        timerAbility = TimerWidgetAbility(),
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      timer.addListener((state) {
        ref.read(stateMinesweeper.notifier).playtime = state;
      });
      final logic = ref.read(stateMinesweeper.notifier);
      if (widget.newGame) {
        logic.initGame(gameMode: SettingsMinesweeper.$.pref.mode);
      } else {
        final save = StorageMinesweeper.save.load();
        if (save != null) {
          logic.fromSave(save);
          timer.state = ref.read(stateMinesweeper).playtime;
        } else {
          logic.initGame(gameMode: SettingsMinesweeper.$.pref.mode);
          timer.state = ref.read(stateMinesweeper).playtime;
        }
      }
    });
  }

  void onSave() {
    ref.read(stateMinesweeper.notifier).save();
  }

  void resetGame() {
    timer.reset();
    ref.read(stateMinesweeper.notifier).initGame(gameMode: ref.read(stateMinesweeper).mode);
  }

  void onGameStateChange(GameStateMinesweeper? former, GameStateMinesweeper current) {
    switch (current.status) {
      case GameStatus.running:
        if (!timer.timerStart) timer.startTimer();
        break;
      case GameStatus.idle:
      case GameStatus.gameOver:
      case GameStatus.victory:
        if (timer.timerStart) timer.stopTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateMinesweeper);
    ref.listen(stateMinesweeper, onGameStateChange);
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
      body: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const GameHud().padH(8),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Center(
                child: Stack(
                  children: [
                    GameBoard(screen: screen),
                    if (state.status == GameStatus.gameOver)
                      GameOverModal(
                        resetGame: resetGame,
                      )
                    else if (state.status == GameStatus.victory)
                      VictoryModal(
                        resetGame: resetGame,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        VictoryPartyPopper(
          pop: state.status == GameStatus.victory,
        ),
      ].stack(),
    );
  }
}
