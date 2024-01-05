import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/gamelogic.dart';
import '../components/cell.dart';
import '../theme/colors.dart';


class GameBoard extends ConsumerWidget {
  const GameBoard({super.key, required this.refresh});
  final roundwidth = 5.0;
  final Function refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardwidth = cellwidth * boardcols + roundwidth * 2;
    final boardheight = cellwidth * boardrows + roundwidth * 2;

    return Container(
      width: boardwidth,height: boardheight,
      decoration: BoxDecoration(
          color: boardcolor,
          border: Border.all(
            color: boardroundcolor,
            width: roundwidth,
          ),
          borderRadius: BorderRadius.all(Radius.circular(roundwidth))
      ),
      child: Stack(
        children: List.generate(boardrows * boardcols, (i) {
          var col = i % boardcols;
          var row = (i / boardcols).floor();
          return Positioned(
              left: col * cellwidth * 1.0,
              top: row * cellwidth * 1.0,
              child: CellWidget(row: row, col: col, refresh: refresh)
          );}
        )
      ),
    );
  }
}
