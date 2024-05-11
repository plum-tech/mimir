import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/ability/ability.dart';
import 'package:sit/game/ability/autosave.dart';
import 'package:sit/game/ability/timer.dart';
import 'package:sit/game/entity/game_status.dart';
import 'package:sit/game/entity/timer.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/board.dart';
import '../i18n.dart';
import '../entity/state.dart';
import '../entity/note.dart';
import '../entity/sudoku_state.dart';
import '../manager/logic.dart';
import '../widget/cell.dart';
import '../widget/filler.dart';
import '../widget/hud.dart';
import '../widget/tool.dart';

final Logger log = Logger();
final stateSudoku = StateNotifierProvider.autoDispose<GameLogic, GameStateSudoku>((ref) {
  return GameLogic();
});

class GameSudoku extends ConsumerStatefulWidget {
  const GameSudoku({super.key});

  @override
  ConsumerState<GameSudoku> createState() => _GameSudokuState();
}

class _GameSudokuState extends ConsumerState<GameSudoku> with WidgetsBindingObserver, GameWidgetAbilityMixin {
  int selectedCellIndex = 0;
  bool enableNoting = false;

  SudokuState get _state => throw 0;

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
    });
  }

  bool _isOnlyReadGrid(int index) => (_state.sudoku?.puzzle[index] ?? 0) != -1;

  void _gameStackCount() {
    if (_state.isComplete) {
      _pauseTimer();
      _state.updateStatus(SudokuGameStatus.success);
      return _gameOver();
    }
  }

  /// game over trigger function
  /// 游戏结束触发 执行判断逻辑
  void _gameOver() async {
    bool isWinner = _state.status == SudokuGameStatus.success;

    // define i18n end
    if (isWinner) {
    } else {}
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_state.sudoku == null) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Sudoku Exiting...',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
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
        return CellWidget(
          index: index,
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
    return NumberFillerArea(
      onNumberTap: (int number) {
        return _state.hasNumStock(number)
            ? () {
                fillNumber(number);
              }
            : null;
      },
    );
  }

  Widget buildToolBar() {
    // define i18n text end
    return [
      ClearNumberButton(
        onTap: clearSelected,
      ),
      // tips 提示
      HintButton(
        onTap: _state.hint > 0 ? hint : null,
      ),
      // mark 笔记
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
    if (cell.canUserInput) return;
    final logic = ref.read(stateSudoku.notifier);
    // Take note or take off
    if (enableNoting) {
      final isNoted = logic.getNoted(cellIndex, number);
      logic.setNoted(cellIndex, number, !isNoted);
      return;
    }
    // Fill the number or toggle the number
    logic.fillCell(cellIndex, number);
    // 判断真伪
    if (_state.records[cellIndex] != -1 && _state.sudoku!.solution[cellIndex] != number) {
      // 填入错误数字 wrong answer on _chooseSudokuBox with num
      _state.lifeLoss();
      if (_state.life <= 0) {
        // 游戏结束
        _gameOver();
      } else {
        await context.showTip(title: "Oops...", desc: "wrongInputAlertText", primary: 'ok');
      }
      return;
    }
    // check win
    _gameStackCount();
  }

  void clearSelected() {
    log.d("""
                  when ${selectedCellIndex + 1} is not a puzzle , then clean the choose \n
                清除 ${selectedCellIndex + 1} 选型 , 如果他不是固定值的话
                """);
    if (_isOnlyReadGrid(selectedCellIndex)) {
      // read only item , skip it - 只读格
      return;
    }
    if (_state.status != SudokuGameStatus.gaming) {
      // not playing , skip it - 未在游戏进行时
      return;
    }
    _state.cleanMark(selectedCellIndex);
    _state.cleanRecord(selectedCellIndex);
  }

  void hint() {
    // tips next cell answer
    log.d("top tips button");
    int hint = _state.hint;
    if (hint <= 0) {
      return;
    }
    List<int> puzzle = _state.sudoku!.puzzle;
    List<int> solution = _state.sudoku!.solution;
    List<int> record = _state.records;
    // random point tips
    int randomBeginPoint = Random().nextInt(puzzle.length);
    for (int i = 0; i < puzzle.length; i++) {
      int index = (i + randomBeginPoint) % puzzle.length;
      if (puzzle[index] == -1 && record[index] == -1) {
        _state.setRecord(index, solution[index]);
        _state.hintLoss();
        selectedCellIndex = index;
        _gameStackCount();
        return;
      }
    }
  }

  void onSave() {
    _state.persistent();
    // ref.read(sudokuState.notifier).save();
  }
}
