import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';

class CellButton extends ConsumerWidget{
  const CellButton({super.key, required this.cell, required this.coverVisible, required this.flagVisible, required this.refresh});
  final Cell cell;
  final bool coverVisible;
  final bool flagVisible;
  final void Function() refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(coverVisible){
      return SizedBox(
        width: cellWidth, height: cellWidth,
        child: MaterialButton(
          onPressed: () {
            // Click a Cover Cell => Blank
            if(!flagVisible){
              ref.read(boardManager.notifier).changeCell(cell: cell, state: CellState.blank);
              ref.read(boardManager.notifier).checkRoundCell(checkCell: cell);
              // Check Game State
              if (cell.mine) {
                ref.read(boardManager).gameOver = true;
              } else if (ref.read(boardManager.notifier).checkWin()) {
                ref.read(boardManager).goodGame = true;
              }
              refresh();
            }
            // Click a Flag Cell => Cancel Flag (Covered)
            else{
              ref.read(boardManager.notifier).changeCell(cell: cell, state: CellState.covered);
              refresh();
            }
          },
          onLongPress: () {
            ref.read(boardManager.notifier).changeCell(cell: cell, state: CellState.flag);
            refresh();
          },
        ),
      );
    }else{
      return const SizedBox.shrink();
    }
  }
}
