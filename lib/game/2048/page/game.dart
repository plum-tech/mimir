import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/game/2048/storage.dart';
import 'package:sit/game/ability/ability.dart';
import 'package:sit/game/ability/autosave.dart';

import '../entity/board.dart';
import '../widget/empty_board.dart';
import '../widget/modal.dart';
import '../widget/score_board.dart';
import '../widget/tile_board.dart';
import '../theme.dart';
import '../manager/logic.dart';
import '../i18n.dart';

final state2048 = StateNotifierProvider<GameLogic, Board>((ref) {
  return GameLogic(ref);
});

class Game2048 extends ConsumerStatefulWidget {
  final bool newGame;

  const Game2048({
    super.key,
    this.newGame = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameState();
}

class _GameState extends ConsumerState<Game2048>
    with TickerProviderStateMixin, WidgetsBindingObserver, GameWidgetAbilityMixin {
  //The controller used to move the the tiles
  late final AnimationController _moveController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..addStatusListener((status) {
      //When the movement finishes merge the tiles and start the scale animation which gives the pop effect.
      if (status == AnimationStatus.completed) {
        ref.read(state2048.notifier).merge();
        _scaleController.forward(from: 0.0);
      }
    });

  //The curve animation for the move animation controller.
  late final CurvedAnimation _moveAnimation = CurvedAnimation(
    parent: _moveController,
    curve: Curves.easeInOut,
  );

  //The controller used to show a popup effect when the tiles get merged
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..addStatusListener((status) {
      //When the scale animation finishes end the round and if there is a queued movement start the move controller again for the next direction.
      if (status == AnimationStatus.completed) {
        if (ref.read(state2048.notifier).endRound()) {
          _moveController.forward(from: 0.0);
        }
      }
    });

  //The curve animation for the scale animation controller.
  late final CurvedAnimation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOut,
  );
  final $focus = FocusNode();
  @override
  List<GameWidgetAbility> createAbility() => [AutoSaveWidgetAbility(onSave: onSave)];
  @override
  void initState() {
    super.initState();
    //Add an Observer for the Lifecycles of the App
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (widget.newGame) {
        ref.read(state2048.notifier).newGame();
      } else {
        final save = Storage2048.save.load();
        if (save != null) {
          ref.read(state2048.notifier).fromSave(Board.fromSave(save));
        } else {
          ref.read(state2048.notifier).newGame();
        }
      }
    });
  }

  @override
  void dispose() {
    $focus.dispose();
    //Dispose the animations.
    _moveAnimation.dispose();
    _scaleAnimation.dispose();
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void onSave() {
    ref.read(state2048.notifier).save();
  }

  @override
  Widget build(BuildContext context) {
    final board = ref.watch(state2048);
    return Scaffold(
      appBar: AppBar(
        title: i18n.title.text(),
        actions: [
          PlatformIconButton(
            onPressed: () {
              ref.read(state2048.notifier).newGame();
            },
            icon: Icon(context.icons.refresh),
          )
        ],
      ),
      body: KeyboardListener(
        autofocus: true,
        focusNode: $focus,
        onKeyEvent: (event) {
          //Move the tile with the arrows on the keyboard on Desktop
          if (!_moveController.isCompleted) return;
          if (ref.read(state2048.notifier).onKey(event)) {
            _moveController.forward(from: 0.0);
          }
        },
        child: SwipeDetector(
          onSwipe: (direction, offset) {
            if (ref.read(state2048.notifier).move(direction)) {
              _moveController.forward(from: 0.0);
            }
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2048',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 52.0),
                      ),
                      ScoreBoard(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Stack(
                  children: [
                    const EmptyBoardWidget(),
                    TileBoardWidget(
                      moveAnimation: _moveAnimation,
                      scaleAnimation: _scaleAnimation,
                    ),
                    if (board.over)
                      const Positioned.fill(
                        child: GameOverModal(),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
