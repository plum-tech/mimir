import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import 'mineboard.dart';


// Debug Tool
final logger = Logger();

// Board Size
const cellWidth = 40.0;
const cellRadius = 2.0;

const boardRows = 15;
const boardCols = 8;
const borderWidth = 5.0;

const boardWidth = cellWidth * boardCols + borderWidth * 2;
const boardHeight = cellWidth * boardRows + borderWidth * 2;

class GameLogic extends StateNotifier<GameStates>{
  GameLogic(this.ref) : super(GameStates());
  final StateNotifierProviderRef ref;
  int mineNum = (boardRows * boardCols * 0.15).floor();
  bool firstClick = true;

  void initGame(){
    state.gameOver = false;
    state.goodGame = false;
    state.board = MineBoard(rows: boardRows, cols: boardCols);
    firstClick = true;
    if (kDebugMode) {
      logger.log(Level.info, "Game init finished");
    }
  }

  void checkRoundCell({required row, required col}){
    if(firstClick){
      state.board.randomMine(number: mineNum, clickrow: row, clickcol: col);
      firstClick = false;
    }
    var dx = [1, 0, -1, 0];
    var dy = [0, 1, 0, -1];
    for(int i = 0; i < 4; i++){
      var nextRow = row + dy[i];
      nextRow = nextRow < 0 ? 0 : nextRow;
      nextRow = nextRow >= boardRows ? boardRows - 1 : nextRow;
      var nextCol = col + dx[i];
      nextCol = nextCol < 0 ? 0 : nextCol;
      nextCol = nextCol >= boardCols ? boardCols - 1 : nextCol;
      // Get the next pose cell state
      Cell cell = getCell(row: nextRow, col: nextCol);
      // Check the next cell
      if(cell.state == CellState.covered && cell.around == 0){
        changeCell(row: nextRow, col: nextCol, state: CellState.blank);
        checkRoundCell(row: nextRow, col: nextCol);
      }else if(!cell.mine && cell.state == CellState.covered && cell.around != 0){
        changeCell(row: nextRow, col: nextCol, state: CellState.blank);
      }
    }
  }

  bool checkWin(){
    var coveredCells = state.board.countState(state: CellState.covered);
    var flagCells = state.board.countState(state: CellState.flag);
    var mineCells = state.board.countMines();
    if (kDebugMode) {
      logger.log(
          Level.debug,
          "mines: $mineCells, covers: $coveredCells, flags: $flagCells",
      );
    }
    if(coveredCells + flagCells == mineCells){
      return true;
    }
    return false;
  }

  Cell getCell({required row, required col}){
    return state.board.getCell(row: row, col: col);
  }

  void changeCell({required row, required col, required state}){
    this.state.board.changeCell(row: row, col: col, state: state);
  }
}

class GameStates{
  late bool gameOver;
  late bool goodGame;
  late MineBoard board;
}

final boardManager = StateNotifierProvider<GameLogic, GameStates>((ref) {
  return GameLogic(ref);
});
