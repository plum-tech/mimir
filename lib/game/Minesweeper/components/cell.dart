import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';


class CellWidget extends ConsumerWidget{
  const CellWidget({super.key,required this.row, required this.col, required this.refresh});
  final Function refresh;
  final int row;
  final int col;
  final cellroundwidth = 2.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);
    switch (_cell["state"]){
      case cellstate.covered:
        return Container(
          width: cellwidth, height: cellwidth,
          decoration: BoxDecoration(
            color: cellcolor,
            border: Border.all(width: cellroundwidth, color: cellroundcolor),
            borderRadius: BorderRadius.all(Radius.circular(cellroundwidth))
          ),
          child: MaterialButton(onPressed: () {
            if(ref.read(boardManager).grab){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.blank);
              ref.read(boardManager.notifier).checkCell(row: row, col: col);
              if(_cell["mine"]){
                ref.read(boardManager).gameover = true;
                print("game over!");
              }else if(ref.read(boardManager.notifier).checkWin()){
                ref.read(boardManager).goodgame = true;
                print("good game");
              }
              refresh();
            }else if(ref.read(boardManager).flag){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.flag);
              refresh();
            }
          },),
        );
      case cellstate.flag:
        return Container(
          width: cellwidth, height: cellwidth,
          decoration: BoxDecoration(
              color: cellcolor,
              border: Border.all(width: cellroundwidth, color: cellroundcolor),
              borderRadius: BorderRadius.all(Radius.circular(cellroundwidth))
          ),
          child: Stack(
            children: [
              Icon(Icons.flag,color: flagcellcolor),
              MaterialButton(onPressed: () {
                if(ref.read(boardManager).flag){
                  ref.read(boardManager.notifier).changeCell(
                      row: row, col: col, state: cellstate.covered);
                  refresh();
                }
              },),
            ],
          )
          );
      case cellstate.blank:
        var _mine = _cell["mine"];
        if(!_mine) {
          return Container(
              width: cellwidth, height: cellwidth, color: boardcolor,
            child: (_cell["around"] != 0)
            ? Text(_cell["around"].toString(),
                style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                textAlign: TextAlign.center)
            : null,
          );
        }else{
          return Container(
            width: cellwidth, height: cellwidth, color: boardcolor,
            child: const Icon(Icons.gps_fixed,color: minecellcolor,)
          );
        }
      default:
        print("Error! wrong cell state");
        return Container(width: cellwidth,height: cellwidth,color: errorcolor);
    }
  }
}
