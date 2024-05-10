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
import 'package:sit/game/entity/timer.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/state.dart';
import '../entity/sudoku_state.dart';
import '../manager/logic.dart';
import '../widget/cell.dart';
import '../widget/filler.dart';
import '../widget/hud.dart';
import '../widget/tool.dart';

final Logger log = Logger();
final sudokuState = StateNotifierProvider.autoDispose<GameLogic, GameStateSudoku>((ref) {
  return GameLogic();
});

class GameSudoku extends ConsumerStatefulWidget {
  const GameSudoku({super.key});

  @override
  ConsumerState<GameSudoku> createState() => _GameSudokuState();
}

class _GameSudokuState extends ConsumerState<GameSudoku> with WidgetsBindingObserver, GameWidgetAbilityMixin {
  int selectedIndex = 0;
  bool _markOpen = false;

  SudokuState get _state => ScopedModel.of<SudokuState>(context);

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
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.endOfFrame.then((_) {
      timer.addListener((state) {
        // ref.read(minesweeperState.notifier).playtime = state;
        if (_state.status == SudokuGameStatus.gaming) {
          _state.tick();
          return;
        }
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

  void onSelectedCell(index) {
    setState(() {
      selectedIndex = index;
    });
    if (_state.sudoku!.puzzle[index] != -1) {
      return;
    }
    log.d('choose position : $index');
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
          GameHud(
            life: _state.life,
            hint: _state.hint,
            gameMode: _state.level!,
            time: _state.timer,
          ),
          buildCells(),
          buildToolBar(),
          buildFiller(),
        ],
      ),
    );
  }

  Widget buildCells() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 81,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
      itemBuilder: (context, index) {
        // 用户做标记
        bool isNoted = _state.sudoku!.puzzle[index] == -1 && _state.records[index].any((element) => element);
        return CellWidget(
          index: index,
          onTap: () {
            onSelectedCell(index);
          },
          selectedIndex: selectedIndex,
          child: isNoted ? buildNotes(index) : buildNumber(index),
        );
      },
    );
  }

  Widget buildNumber(int index) {
    final sudoku = _state.sudoku!;
    final puzzle = sudoku.puzzle;
    final solution = sudoku.solution;
    final record = _state.records;
    return CellNumber(
      userInput: puzzle[index] > 0
          ? -1
          : record[index] <= 0
              ? 0
              : record[index],
      correctValue: puzzle[index] <= 0 ? solution[index] : puzzle[index],
    );
  }

  Widget buildNotes(int index) {
    final notes = <int>{};
    final notesRaw = _state.records[index];
    for (var i = 0; i < notesRaw.length; i++) {
      if (notesRaw[i]) {
        notes.add(i);
      }
    }
    return CellNotes(
      cellSelected: selectedIndex == index,
      notes: notes,
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
        enabled: _markOpen,
        onChanged: (newV) {
          setState(() {
            _markOpen = !_markOpen;
          });
        },
      ),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }

  void fillNumber(int number) async {
    log.d("input : $number");
    if (_isOnlyReadGrid(selectedIndex)) {
      // 非填空项
      return;
    }
    if (_state.status != SudokuGameStatus.gaming) {
      // 未在游戏进行时
      return;
    }
    if (_markOpen) {
      /// markOpen , mean use mark notes
      log.d("填写笔记");
      _state.switchMark(selectedIndex, number);
      return;
    }
    // 填写数字
    _state.switchRecord(selectedIndex, number);
    // 判断真伪
    if (_state.records[selectedIndex] != -1 && _state.sudoku!.solution[selectedIndex] != number) {
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
                  when ${selectedIndex + 1} is not a puzzle , then clean the choose \n
                清除 ${selectedIndex + 1} 选型 , 如果他不是固定值的话
                """);
    if (_isOnlyReadGrid(selectedIndex)) {
      // read only item , skip it - 只读格
      return;
    }
    if (_state.status != SudokuGameStatus.gaming) {
      // not playing , skip it - 未在游戏进行时
      return;
    }
    _state.cleanMark(selectedIndex);
    _state.cleanRecord(selectedIndex);
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
        selectedIndex = index;
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
