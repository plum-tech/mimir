import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sit/game/ability/ability.dart';
import 'package:sit/game/ability/autosave.dart';
import 'package:sit/game/ability/timer.dart';
import 'package:sit/game/entity/timer.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

import '../i18n.dart';
import '../entity/state.dart';
import '../entity/sudoku_state.dart';
import '../manager/logic.dart';

final Logger log = Logger();
final sudokuState = StateNotifierProvider.autoDispose<GameLogic, GameStateSudoku>((ref) {
  return GameLogic();
});
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.black54,
  shadowColor: Colors.blue,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

final ButtonStyle primaryFlatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.lightBlue,
  shadowColor: Colors.blue,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

class GameSudoku extends ConsumerStatefulWidget {
  const GameSudoku({super.key});

  @override
  ConsumerState<GameSudoku> createState() => _GameSudokuState();
}

class _GameSudokuState extends ConsumerState<GameSudoku> with WidgetsBindingObserver, GameWidgetAbilityMixin {
  int _chooseSudokuBox = 0;
  bool _markOpen = false;
  bool _manualPause = false;

  SudokuState get _state => ScopedModel.of<SudokuState>(context);

  bool _isOnlyReadGrid(int index) => (_state.sudoku?.puzzle[index] ?? 0) != -1;

  // 游戏盘点，检查是否游戏结束
  // check the game is done
  void _gameStackCount() {
    if (_state.isComplete) {
      _pauseTimer();
      _state.updateStatus(SudokuGameStatus.success);
      return onGameOver();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sudoku")),
      body: _bodyWidget(context),
    );
  }

  void onGameOver() async {}

  // fill zone [ 1 - 9 ]
  Widget _fillZone(BuildContext context) {
    List<Widget> fillTools = List.generate(9, (index) {
      int num = index + 1;
      bool hasNumStock = _state.hasNumStock(num);
      var fillOnPressed;
      if (!hasNumStock) {
        fillOnPressed = null;
      } else {
        fillOnPressed = () async {
          log.d("input : $num");
          if (_isOnlyReadGrid(_chooseSudokuBox)) {
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
            _state.switchMark(_chooseSudokuBox, num);
          } else {
            // 填写数字
            _state.switchRecord(_chooseSudokuBox, num);
            // 判断真伪
            if (_state.record[_chooseSudokuBox] != -1 && _state.sudoku!.solution[_chooseSudokuBox] != num) {
              // 填入错误数字 wrong answer on _chooseSudokuBox with num
              _state.lifeLoss();
              if (_state.life <= 0) {
                // 游戏结束
                return onGameOver();
              }

              // "\nWrong Input\nYou can't afford ${_state.life} more turnovers"
              String wrongInputAlertText = "wrongInputAlertText";
              String gotItText = "gotItText";

              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("Oops..."),
                      content: Text(wrongInputAlertText),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(gotItText),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });

              return;
            }
            _gameStackCount();
          }
        };
      }

      Color recordFontColor = hasNumStock ? Colors.black : Colors.white;
      Color recordBgColor = hasNumStock ? Colors.black12 : Colors.white24;

      Color markFontColor = hasNumStock ? Colors.white : Colors.white;
      Color markBgColor = hasNumStock ? Colors.black : Colors.white24;

      return Expanded(
          flex: 1,
          child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(border: BorderDirectional()),
              child: CupertinoButton(
                  color: _markOpen ? markBgColor : recordBgColor,
                  padding: EdgeInsets.all(1),
                  child: Text('${index + 1}',
                      style: TextStyle(
                          color: _markOpen ? markFontColor : recordFontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  onPressed: fillOnPressed)));
    });

    fillTools.add(Expanded(
        flex: 1,
        child: Container(
            child: CupertinoButton(
                padding: EdgeInsets.all(8),
                child: Image(image: AssetImage("assets/image/icon_eraser.png"), width: 40, height: 40),
                onPressed: () {
                  log.d("""
                  when ${_chooseSudokuBox + 1} is not a puzzle , then clean the choose \n
                  清除 ${_chooseSudokuBox + 1} 选型 , 如果他不是固定值的话
                  """);
                  if (_isOnlyReadGrid(_chooseSudokuBox)) {
                    // read only item , skip it - 只读格
                    return;
                  }
                  if (_state.status != SudokuGameStatus.gaming) {
                    // not playing , skip it - 未在游戏进行时
                    return;
                  }
                  _state.cleanMark(_chooseSudokuBox);
                  _state.cleanRecord(_chooseSudokuBox);
                }))));

    return Align(
        alignment: Alignment.centerLeft,
        child: Container(height: 40, width: MediaQuery.of(context).size.width, child: Row(children: fillTools)));
  }

  Widget _toolZone(BuildContext context) {
    return Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: Row(children: <Widget>[
          // tips 提示
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                      padding: EdgeInsets.all(5),
                      onPressed: _state.hint > 0
                          ? () {
                              // tips next cell answer
                              log.d("top tips button");
                              int hint = _state.hint;
                              if (hint <= 0) {
                                return;
                              }
                              List<int> puzzle = _state.sudoku!.puzzle;
                              List<int> solution = _state.sudoku!.solution;
                              List<int> record = _state.record;
                              // random point tips
                              int randomBeginPoint = new Random().nextInt(puzzle.length);
                              for (int i = 0; i < puzzle.length; i++) {
                                int index = (i + randomBeginPoint) % puzzle.length;
                                if (puzzle[index] == -1 && record[index] == -1) {
                                  _state.setRecord(index, solution[index]);
                                  _state.hintLoss();
                                  _chooseSudokuBox = index;
                                  _gameStackCount();
                                  return;
                                }
                              }
                            }
                          : null,
                      child: Text("tipsText", style: TextStyle(fontSize: 15))))),
          // mark 笔记
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                      padding: EdgeInsets.all(5),
                      onPressed: () {
                        log.d("enable mark function - 启用笔记功能");
                        setState(() {
                          _markOpen = !_markOpen;
                        });
                      },
                      child: Text("${_markOpen ? "close note" : "enable note"}", style: TextStyle(fontSize: 15))))),
        ]));
  }

  /// 计算网格背景色
  Color _gridInWellBgColor(int index) {
    Color gridWellBackgroundColor;
    // same zones
    List<int> zoneIndexes = Matrix.getZoneIndexes(zone: Matrix.getZone(index: index));
    // same rows
    List<int> rowIndexes = Matrix.getRowIndexes(Matrix.getRow(index));
    // same columns
    List<int> colIndexes = Matrix.getColIndexes(Matrix.getCol(index));

    Set indexSet = Set();
    indexSet.addAll(zoneIndexes);
    indexSet.addAll(rowIndexes);
    indexSet.addAll(colIndexes);

    if (index == _chooseSudokuBox) {
      gridWellBackgroundColor = Color.fromARGB(255, 0x70, 0xF3, 0xFF);
    } else if (indexSet.contains(_chooseSudokuBox)) {
      gridWellBackgroundColor = Color.fromARGB(255, 0x44, 0xCE, 0xF6);
    } else {
      if (Matrix.getZone(index: index).isOdd) {
        gridWellBackgroundColor = Colors.white;
      } else {
        gridWellBackgroundColor = Color.fromARGB(255, 0xCC, 0xCC, 0xCC);
      }
    }
    return gridWellBackgroundColor;
  }

  ///
  /// 正常网格控件
  ///
  Widget _gridInWellWidget(BuildContext context, int index, int num, GestureTapCallback onTap) {
    Sudoku sudoku = _state.sudoku!;
    List<int> puzzle = sudoku.puzzle;
    List<int> solution = sudoku.solution;
    List<int> record = _state.record;
    bool readOnly = true;
    bool isWrong = false;
    int num = puzzle[index];
    if (puzzle[index] == -1) {
      num = record[index];
      readOnly = false;

      if (record[index] != -1 && record[index] != solution[index]) {
        isWrong = true;
      }
    }
    return InkWell(
        highlightColor: Colors.blue,
        customBorder: Border.all(color: Colors.blue),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(color: _gridInWellBgColor(index), border: Border.all(color: Colors.black12)),
            child: Text(
              '${num == -1 ? '' : num}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: readOnly ? FontWeight.w800 : FontWeight.normal,
                  color: readOnly ? Colors.blueGrey : (isWrong ? Colors.red : Color.fromARGB(255, 0x3B, 0x2E, 0x7E))),
            ),
          ),
        ),
        onTap: onTap);
  }

  ///
  /// 笔记网格控件
  ///
  Widget _markGridWidget(BuildContext context, int index, GestureTapCallback onTap) {
    Widget markGrid = InkWell(
        highlightColor: Colors.blue,
        customBorder: Border.all(color: Colors.blue),
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(color: _gridInWellBgColor(index), border: Border.all(color: Colors.black12)),
            child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (BuildContext context, int _index) {
                  String markNum = '${_state.mark[index][_index + 1] ? _index + 1 : ""}';
                  return Text(markNum,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _chooseSudokuBox == index ? Colors.white : Color.fromARGB(255, 0x16, 0x69, 0xA9),
                          fontSize: 12));
                })));

    return markGrid;
  }

  _wellOnTapBuilder(index) {
    return () {
      setState(() {
        _chooseSudokuBox = index;
      });
      if (_state.sudoku!.puzzle[index] != -1) {
        return;
      }
      log.d('choose position : $index');
    };
  }

  Widget _bodyWidget(BuildContext context) {
    if (_state.sudoku == null) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Center(
            child: Text('Sudoku Exiting...', style: TextStyle(color: Colors.black), textDirection: TextDirection.ltr)),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /// status zone
          /// life / tips / timer on here
          Container(
            height: 50,
            padding: EdgeInsets.all(10.0),
//                color: Colors.red,
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(children: <Widget>[
                    Icon(Icons.heart_broken),
                    Text(" x ${_state.life}", style: TextStyle(fontSize: 18))
                  ])),
              // indicator
              Expanded(
                flex: 2,
                child: Container(
                    alignment: AlignmentDirectional.center,
                    child: Text("${_state.level!.l10n()} - ${_state.timer} - ${_state.status}")),
              ),
              // tips
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                    Icon(Icons.lightbulb),
                    Text(" x ${_state.hint}", style: TextStyle(fontSize: 18))
                  ])))
            ]),
          ),

          /// 9 x 9 cells sudoku puzzle board
          /// the whole sudoku game draw it here
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 81,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
              itemBuilder: ((BuildContext context, int index) {
                int num = -1;
                if (_state.sudoku?.puzzle.length == 81) {
                  num = _state.sudoku!.puzzle[index];
                }

                // 用户做标记
                bool isUserMark = _state.sudoku!.puzzle[index] == -1 && _state.mark[index].any((element) => element);

                if (isUserMark) {
                  return _markGridWidget(context, index, _wellOnTapBuilder(index));
                }

                return _gridInWellWidget(context, index, num, _wellOnTapBuilder(index));
              })),

          /// user input zone
          /// use fillZone choose number fill cells or mark notes
          /// use toolZone to pause / exit game
          Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 5)),
          _fillZone(context),
          _toolZone(context)
        ],
      ),
    );
  }

  void onSave() {
    _state.persistent();
    // ref.read(sudokuState.notifier).save();
  }
}
