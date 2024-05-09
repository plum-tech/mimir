import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/build_context.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

import '../entity/mode.dart';
import '../entity/state.dart';
import '../manager/logic.dart';
import '../widget/difficulty.dart';
import '../widget/game_over.dart';
import '../widget/numbers.dart';
import '../board_style.dart';

final sudokuState = StateNotifierProvider.autoDispose<GameLogic, GameStateSudoku>((ref) {
  return GameLogic();
});

class GameSudoku extends ConsumerStatefulWidget {
  const GameSudoku({super.key});

  @override
  ConsumerState<GameSudoku> createState() => GameSudokuState();
}

class GameSudokuState extends ConsumerState<GameSudoku> {
  bool firstRun = true;
  bool gameOver = false;
  int timesCalled = 0;
  bool isButtonDisabled = false;

  late ({List<List<int>> puzzle, List<List<int>> solved}) gameList;

  late List<List<int>> game;
  late List<List<int>> gameCopy;
  late List<List<int>> gameSolved;
  var gameMode = GameMode.easy;

  @override
  void initState() {
    super.initState();
    newGame(gameMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sudoku'),
      ),
      body: Builder(builder: (builder) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: createRows(),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: showOptionModalSheet,
        child: const Icon(Icons.menu_rounded),
      ),
    );
  }

  Future<void> checkResult() async {
    try {
      if (SudokuUtilities.isSolved(game)) {
        isButtonDisabled = !isButtonDisabled;
        gameOver = true;
        await context.showDialog(
          (_) => const AlertGameOver(),
        );
        if (AlertGameOver.newGame) {
          newGame();
          AlertGameOver.newGame = false;
        } else if (AlertGameOver.restartGame) {
          restartGame();
          AlertGameOver.restartGame = false;
        }
      }
    } on InvalidSudokuConfigurationException {
      return;
    }
  }

  static Future<({List<List<int>> puzzle, List<List<int>> solved})> getNewGame(
      [GameMode gameMode = GameMode.easy]) async {
    SudokuGenerator generator = SudokuGenerator(emptySquares: gameMode.blanks);
    return (puzzle: generator.newSudoku, solved: generator.newSudokuSolved);
  }

  static List<List<int>> copyGrid(List<List<int>> grid) {
    return grid.map((row) => [...row]).toList();
  }

  void setGame(int mode, [GameMode gameMode = GameMode.easy]) async {
    if (mode == 1) {
      game = List.filled(9, [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      gameCopy = List.filled(9, [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      gameSolved = List.filled(9, [0, 0, 0, 0, 0, 0, 0, 0, 0]);
    } else {
      gameList = await getNewGame(gameMode);
      game = gameList.puzzle;
      gameCopy = copyGrid(game);
      gameSolved = gameList.solved;
    }
  }

  void showSolution() {
    setState(() {
      game = copyGrid(gameSolved);
      isButtonDisabled = !isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = true;
    });
  }

  void newGame([GameMode gameMode = GameMode.easy]) {
    setState(() {
      this.gameMode = gameMode;
      setGame(2, gameMode);
      isButtonDisabled = isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  void restartGame() {
    setState(() {
      game = copyGrid(gameCopy);
      isButtonDisabled = isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  List<SizedBox> createButtons() {
    if (firstRun) {
      setGame(1);
      firstRun = false;
    }

    List<SizedBox> buttonList = List<SizedBox>.filled(9, const SizedBox());
    for (var i = 0; i <= 8; i++) {
      var k = timesCalled;
      buttonList[i] = SizedBox(
        key: Key('grid-button-$k-$i'),
        width: 38,
        height: 38,
        child: TextButton(
          onPressed: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () async {
                  await context.showDialog(
                    (_) => const AlertNumbersState(),
                  );
                  callback([k, i], AlertNumbersState.number);
                  AlertNumbersState.number = null;
                },
          onLongPress: isButtonDisabled || gameCopy[k][i] != 0 ? null : () => callback([k, i], 0),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return gameCopy[k][i] == 0
                    ? gameOver
                        ? Colors.red
                        : Colors.green
                    : Colors.white;
              }
              return game[k][i] == 0 ? Colors.grey : Colors.green;
            }),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: buttonEdgeRadius(k, i),
            )),
            side: MaterialStateProperty.all<BorderSide>(BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: context.colorScheme.onSurface,
            )),
          ),
          child: Text(
            game[k][i] != 0 ? game[k][i].toString() : ' ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    timesCalled++;
    if (timesCalled == 9) {
      timesCalled = 0;
    }
    return buttonList;
  }

  Row oneRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: createButtons(),
    );
  }

  List<Row> createRows() {
    List<Row> rowList = List<Row>.generate(9, (i) => oneRow());
    return rowList;
  }

  void callback(List<int> index, int? number) {
    setState(() {
      if (number == null) {
        return;
      } else if (number == 0) {
        game[index[0]][index[1]] = number;
      } else {
        game[index[0]][index[1]] = number;
        checkResult();
      }
    });
  }

  Future<void> showOptionModalSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Restart Game'),
              onTap: () {
                Navigator.pop(context);
                restartGame();
              },
            ),
            ListTile(
              leading: Icon(Icons.add_rounded),
              title: Text('New Game'),
              onTap: () {
                Navigator.pop(context);
                newGame(gameMode);
              },
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline_rounded),
              title: Text('Show Solution'),
              onTap: () {
                Navigator.pop(context);
                showSolution();
              },
            ),
            ListTile(
              leading: Icon(Icons.build_outlined),
              title: Text('Game mode'),
              onTap: () async {
                Navigator.pop(context);
                final newGameMode = await context.showDialog(
                  (_) => GameModeDialog(initial: gameMode),
                );
                if (newGameMode != null) {
                  newGame(newGameMode);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
