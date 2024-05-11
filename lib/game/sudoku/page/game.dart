// Thanks to "https://github.com/einsitang/sudoku-flutter"
// LICENSE: https://github.com/einsitang/sudoku-flutter/blob/fc31c063d84ba272bf30219ea08724272167b8ef/LICENSE
// Modifications copyright©️2023–2024 Liplum Dev.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/ability/ability.dart';
import 'package:sit/game/ability/autosave.dart';
import 'package:sit/game/ability/timer.dart';
import 'package:sit/game/entity/game_status.dart';
import 'package:sit/game/entity/timer.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/mode.dart';
import '../entity/state.dart';
import '../manager/logic.dart';
import '../widget/cell.dart';
import '../widget/filler.dart';
import '../widget/hud.dart';
import '../widget/tool.dart';

final stateSudoku = StateNotifierProvider.autoDispose<GameLogic, GameStateSudoku>((ref) {
  return GameLogic();
});

class GameSudoku extends ConsumerStatefulWidget {
  final bool newGame;

  const GameSudoku({
    super.key,
    this.newGame = true,
  });

  @override
  ConsumerState<GameSudoku> createState() => _GameSudokuState();
}

class _GameSudokuState extends ConsumerState<GameSudoku> with WidgetsBindingObserver, GameWidgetAbilityMixin {
  int selectedCellIndex = 0;
  bool enableNoting = false;

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
        ref.read(stateSudoku.notifier).playtime = state;
      });
      final logic = ref.read(stateSudoku.notifier);
      if (widget.newGame) {
        logic.initGame(gameMode: GameMode.easy);
        logic.startGame();
      } else {
        // final save = SaveSudoku.storage.load();
        // if (save != null) {
        //   logic.fromSave(save);
        //   timer.state = ref.read(stateSudoku).playtime;
        // } else {
        //   logic.initGame(gameMode: GameMode.easy);
        //   timer.state = ref.read(stateSudoku).playtime;
        // }
      }
    });
  }

  void onGameStateChange(GameStateSudoku? former, GameStateSudoku current) {
    switch (current.status) {
      case GameStatus.running:
        if (!timer.timerStart) {
          timer.startTimer();
        }
      case GameStatus.idle:
      case GameStatus.gameOver:
      case GameStatus.victory:
        if (timer.timerStart) {
          timer.stopTimer();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(stateSudoku, onGameStateChange);
    return Scaffold(
      appBar: AppBar(title: Text("Sudoku")),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const GameHud(),
          buildCells(),
          buildToolBar(),
          buildFiller(),
        ],
      ),
    );
  }

  Widget buildCells() {
    final notes = ref.watch(stateSudoku.select((state) => state.notes));
    final board = ref.watch(stateSudoku.select((state) => state.board));
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 81,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
      itemBuilder: (context, index) {
        final note = notes[index];
        final selected = selectedCellIndex == index;
        final cell = board.getCellByIndex(index);
        final zone = board.getZoneWhereCell(cell);
        return CellWidget(
          cell: cell,
          edge: zone.cellOnWhichEdge(cell),
          onTap: () {
            setState(() {
              selectedCellIndex = index;
            });
          },
          selectedIndex: selectedCellIndex,
          child: note.anyNoted
              ? CellNotes(
                  note: note,
                  cellSelected: selected,
                )
              : CellNumber(
                  cell: cell,
                  cellSelected: selected,
                ),
        );
      },
    );
  }

  Widget buildFiller() {
    final board = ref.watch(stateSudoku.select((state) => state.board));
    final gameStatus = ref.watch(stateSudoku.select((state) => state.status));
    return NumberFillerArea(
      onNumberTap: gameStatus.canPlay
          ? (int number) {
              return board.canFill(number: number, cellIndex: selectedCellIndex)
                  ? () {
                      fillNumber(number);
                    }
                  : null;
            }
          : null,
    );
  }

  Widget buildToolBar() {
    final selectedCell = ref.watch(stateSudoku.select((state) => state.board)).getCellByIndex(selectedCellIndex);
    return [
      ClearNumberButton(
        onTap: selectedCell.canUserInput ? clearSelected : null,
      ),
      // HintButton(
      //   onTap: _state.hint > 0 ? hint : null,
      // ),
      NoteNumberButton(
        enabled: enableNoting,
        onChanged: (newV) {
          setState(() {
            enableNoting = !enableNoting;
          });
        },
      ),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }

  void fillNumber(int number) async {
    final state = ref.read(stateSudoku);
    final gameStatus = state.status;
    if (!gameStatus.canPlay) return;
    final cellIndex = selectedCellIndex;
    final cell = state.board.getCellByIndex(cellIndex);
    if (!cell.canUserInput) return;
    final logic = ref.read(stateSudoku.notifier);
    // Take note or take off
    if (enableNoting) {
      final isNoted = logic.getNoted(cellIndex, number);
      logic.setNoted(cellIndex, number, !isNoted);
      return;
    } else {
      logic.clearNote(cellIndex);
    }
    // Fill the number or toggle the number
    logic.fillCell(cellIndex, number);
  }

  void clearSelected() {
    final state = ref.read(stateSudoku);
    final gameStatus = state.status;
    if (!gameStatus.canPlay) return;
    final cellIndex = selectedCellIndex;
    final cell = state.board.getCellByIndex(cellIndex);
    if (!cell.canUserInput) return;
    final logic = ref.read(stateSudoku.notifier);
    logic.clearCell(cellIndex);
  }

  void hint() {}

  void onSave() {
    ref.read(stateSudoku.notifier).save();
  }
}
