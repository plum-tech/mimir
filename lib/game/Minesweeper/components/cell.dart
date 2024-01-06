import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';


class CellWidget extends ConsumerWidget{
  CellWidget({super.key,required this.row, required this.col, required this.refresh});
  final Function refresh;
  final int row;
  final int col;
  late final _cell;
  late final _covered;
  late final _flaged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);

    switch(_cell["state"]){
      case cellstate.blank:
        _covered = false;
        _flaged = false;
      case cellstate.covered:
        _covered = true;
        _flaged = false;
      case cellstate.flag:
        _covered = true;
        _flaged = true;
    }

    return Stack(
      children: [
        widgetBlank(),
        widgetCover(visible: _covered),
        widgetFlag(visible: _flaged),
        Container(
          width: cellwidth, height: cellwidth,
          child: MaterialButton(
            onPressed: () {
              if(!_flaged){
                ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.blank);
                ref.read(boardManager.notifier).checkCell(row: row, col: col);
                if (_cell["mine"]) {
                  ref.read(boardManager).gameover = true;
                } else if (ref.read(boardManager.notifier).checkWin()) {
                  ref.read(boardManager).goodgame = true;
                }
                refresh();
              }else{
                ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.covered);
                refresh();
              }
            },
            onLongPress: () {
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.flag);
              refresh();
            },
          ),
        )
      ],
    );
  }

  Widget widgetFlag({required visible}){
    const _duration = Duration(seconds: 1);
    const _curve = Curves.ease;

    return AnimatedPositioned(
      left: 0,
      top: visible ? 0 : -50,
      duration: _duration,
      curve: _curve,
        child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: _duration,
            curve: _curve,
          child: AnimatedScale(
            scale: visible ? 1 : 0.2,
            duration: _duration,
            curve: _curve,
            child: Icon(
              Icons.flag,
              size: 40,
              color: flagcellcolor,
            ),
          )
        ),
    );
  }

  Widget widgetCover({required visible}){
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 1000),
      child: Container(
        width: cellwidth, height: cellwidth,
        decoration: BoxDecoration(
          color: cellcolor,
          border: Border.all(width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }

  Widget widgetBlank(){
    return Container(
      width: cellwidth, height: cellwidth, color: boardcolor,
      child: _cell["mine"]
          ? Icon(Icons.gps_fixed, color: minecellcolor)
          : numberText(around: _cell["around"]),
    );
  }

  Widget numberText({required around}){
    if(around == 0){
      return const SizedBox.shrink();
    }
    late final Color numcolor;
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
      default:
        numcolor = errorcolor;
    }
    return Text(
      around.toString(),
      style: TextStyle(
          color: numcolor,
          fontWeight: FontWeight.w900,
          fontSize: 28),
      textAlign: TextAlign.center,);
  }
}
