import '../management/gamelogic.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import 'dart:math';

enum CellState{
  covered,
  blank,
  flag,
}

class Cell{
  Cell({required this.row, required this.col});
  final int row;
  final int col;
  bool mine = false;
  CellState state = CellState.covered;
  int around = 0;
}

class MineBoard{
  int mines = 0;
  final int rows;
  final int cols;
  late List<List<Cell>> board;

  MineBoard({required this.rows, required this.cols}){
    board = List.generate(rows, (row) => List.generate(cols,(col) => Cell(row: row, col: col)));
    if (kDebugMode) {
      logger.log(Level.info, "MineBoard Init Finished");
    }
  }

  int countState({required state}){
    var cnt = 0;
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        if(board[r][c].state == state){
          cnt += 1;
        }
      }
    }
    return cnt;
  }

  int countMines(){
    // Return the default mines (required num) first
    if(mines != 0){
      return mines;
    }else {
      var cnt = 0;
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          if (board[r][c].mine) {
            cnt += 1;
          }
        }
      }
      return cnt;
    }
  }

  void randomMines({required number, required clickRow, required clickCol}){
    mines = number;
    int beginSafeRow = clickRow - 1 < 0 ? 0 : clickRow - 1;
    int endSafeRow = clickRow + 1 >= rows ? rows - 1 : clickRow + 1;
    int beginSafeCol = clickCol - 1 < 0 ? 0 : clickCol - 1;
    int endSafeCol = clickCol + 1 >= cols ? cols - 1 : clickCol + 1;
    var cnt = 0;
    while(cnt < number){
      var value = Random().nextInt(cols * rows);
      var col = value % cols;
      var row = (value / cols).floor();
      if(!board[row][col].mine
          && !((row >= beginSafeRow && row <= endSafeRow)
              && (col >= beginSafeCol && col <= endSafeCol))
      ){
        board[row][col].mine = true;
        addRoundCellMineNum(row: row, col: col); // count as mine created
        cnt += 1;
      }
    }
  }

  void addRoundCellMineNum({required row, required col}){
    int beginRow = row - 1 < 0 ? 0 : row - 1;
    int endRow = row + 1 >= rows ? rows - 1 : row + 1;
    int beginCol = col - 1 < 0 ? 0 : col - 1;
    int endCol = col + 1 >= cols ? cols - 1 : col + 1;
    for(int r = beginRow; r <= endRow; r++){
      for(int c = beginCol; c <= endCol; c++){
        board[r][c].around += 1;
      }
    }
  }

  Cell getCell({required row, required col}){
    return board[row][col];
  }

  void changeCell({required row, required col, required state}){
    board[row][col].state = state;
  }
}
