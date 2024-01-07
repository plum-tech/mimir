import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import 'cellwidget.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';



class CellWidget extends ConsumerWidget{
  const CellWidget({super.key, required this.row, required this.col, required this.reFresh});
  final void Function() reFresh;
  final int row;
  final int col;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Cell cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);
    late final bool coverCell;
    late final bool flagCell;

    switch(cell.state){
      case CellState.blank:
        coverCell = false;
        flagCell = false;
      case CellState.covered:
        coverCell = true;
        flagCell = false;
      case CellState.flag:
        coverCell = true;
        flagCell = true;
      default:
        if (kDebugMode) {
          logger.log(
              Level.error,
              "Wrong Cell State"
          );
        }
    }

    return Stack(
      children: [
        widgetBlank(cell: cell),
        widgetCover(visible: coverCell),
        widgetFlag(visible: flagCell),
        widgetButton(cell: cell, covered: coverCell, flaged: flagCell, ref: ref),
      ],
    );
  }

  Widget widgetButton({required Cell cell, required bool covered, required bool flaged, required ref}){
    if(covered){
      return SizedBox(
        width: cellWidth, height: cellWidth,
        child: MaterialButton(
          onPressed: () {
            // Click a Cover Cell => Blank
            if(!flaged){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: CellState.blank);
              ref.read(boardManager.notifier).checkRoundCell(row: row, col: col);
              // Check Game State
              if (cell.mine) {
                ref.read(boardManager).gameOver = true;
              } else if (ref.read(boardManager.notifier).checkWin()) {
                ref.read(boardManager).goodGame = true;
              }
              reFresh();
            }
            // Click a Flag Cell => Cancel Flag (Covered)
            else{
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: CellState.covered);
              reFresh();
            }
          },
          onLongPress: () {
            ref.read(boardManager.notifier).changeCell(row: row, col: col, state: CellState.flag);
            reFresh();
          },
        ),
      );
    }else{
      return const SizedBox.shrink();
    }
  }

}