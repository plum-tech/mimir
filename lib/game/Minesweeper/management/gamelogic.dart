import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mineboard.dart';


final cellwidth = 32.0;
final boardrows = 15;
final boardcols = 10;

class GameLogic extends StateNotifier<GameStates>{
  GameLogic(this.ref) : super(GameStates());

  final StateNotifierProviderRef ref;
  final int minenums = (boardcols * boardrows * 0.15).floor();

  void initGame(){
    state.grab = false;
    state.flag = false;
    state.gameover = false;
    state.goodgame = false;
    state.board = MineBoard(rows: boardrows, cols: boardcols);
    state.board.randomMine(num: minenums);
    print("Game init finished");
  }

  void checkCell({required row, required col}){
    var dx = [1,0,-1,0];
    var dy = [0,1,0,-1];
    for(int i = 0; i < 4; i++){
      var nextrow = row + dy[i];
      if(nextrow < 0){nextrow = 0;}
      if(nextrow >= boardrows){nextrow = boardrows - 1;}
      var nextcol = col + dx[i];
      if(nextcol < 0){nextcol = 0;}
      if(nextcol >= boardcols){nextcol = boardcols - 1;}
      var _cell = getCell(row: nextrow, col: nextcol);
      if(_cell["state"] == cellstate.covered && _cell["around"] == 0){
        changeCell(row: nextrow, col: nextcol, state: cellstate.blank);
        checkCell(row: nextrow, col: nextcol);
      }else if(!_cell["mine"] && _cell["state"] == cellstate.covered && _cell["around"] != 0){
        changeCell(row: nextrow, col: nextcol, state: cellstate.blank);
      }
    }
  }

  bool checkBlank({required row, required col}){
    int checkwidth = 1;
    int beginrow = row - checkwidth < 0 ? 0 : row - checkwidth;
    int endrow = row + checkwidth >= boardrows ? boardrows - 1 : row + checkwidth;
    int begincol = col - checkwidth < 0 ? 0 : col - checkwidth;
    int endcol = col + checkwidth >= boardcols ? boardcols - 1 : col + checkwidth;
    for(int r = beginrow; r <= endrow; r++){
      for(int c = begincol; c <= endcol; c++){
        if(getCell(row: r, col: c)["state"]==cellstate.blank){
          return true;
        }
      }
    }
    return false;
  }

  bool checkWin(){
    if(state.board.countState(state: cellstate.covered) == state.board.countMines()){
      return true;
    }
    return false;
  }

  Map getCell({required row, required col}){
    return state.board.getCell(row: row, col: col);
  }

  void changeCell({required row, required col, required state}){
    this.state.board.changeCell(row: row, col: col, state: state);
  }
}

class GameStates{
  late bool grab;
  late bool flag;
  late bool gameover;
  late bool goodgame;
  late MineBoard board;
}

final boardManager = StateNotifierProvider<GameLogic, GameStates>((ref) {
  return GameLogic(ref);
});
