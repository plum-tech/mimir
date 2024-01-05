import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';


class CellWidget extends ConsumerWidget{
  const CellWidget({super.key,required this.row, required this.col, required this.refresh});
  final Function refresh;
  final int row;
  final int col;

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
            borderRadius: const BorderRadius.all(Radius.circular(cellroundwidth))
          ),
          child: MaterialButton(
            onPressed: () {
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
              },
            onLongPress: (){
                ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.flag);
                refresh();
              },
          ),
        );
      case cellstate.flag:
        return Container(
          width: cellwidth, height: cellwidth,
          decoration: BoxDecoration(
              color: cellcolor,
              border: Border.all(width: cellroundwidth, color: cellroundcolor),
              borderRadius: const BorderRadius.all(Radius.circular(cellroundwidth))
          ),
          child: Stack(
            children: [
              Icon(
                  Icons.flag,
                  size: 32,
                  color: flagcellcolor
              ),
              MaterialButton(
                onPressed: () {
                  ref.read(boardManager.notifier).changeCell(
                      row: row, col: col, state: cellstate.covered);
                  refresh();
                },
              ),
            ],
          )
          );
      case cellstate.blank:
        if(!_cell["mine"]) {
          return Container(
              width: cellwidth, height: cellwidth, color: boardcolor,
            child: (_cell["around"] != 0)
            ? numberText(around: _cell["around"])
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

Widget numberText({required around}){
  late var numcolor;
  switch(around){
    case 1:
      numcolor = num1color;
    case 2:
      numcolor = num2color;
    case 3:
      numcolor = num3color;
    case 4:
      numcolor = num4color;
    case 5:
      numcolor = num5color;
    case 6:
      numcolor = num6color;
    case 7:
      numcolor = num7color;
    case 8:
      numcolor = num8color;
  }
  return Text(
    around.toString(),
    style: TextStyle(
        color: numcolor,
        fontWeight: FontWeight.w900,
        fontSize: 18),
    textAlign: TextAlign.center,);
}
