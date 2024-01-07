import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/gametimer.dart';
import '../management/gamelogic.dart';
import '../components/cell.dart';
import '../theme/colors.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key, required this.reFresh, required this.timer});
  final void Function() reFresh;
  final GameTimer timer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      width: boardWidth,
      height: boardHeight,
      decoration: BoxDecoration(
          color: boardColor,
          border: Border.all(
            color: timer.checkHalfTime() ? crazyColor : boardBorderColor,
            width: borderWidth,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(cellRadius),
          )
      ),
      duration: Durations.extralong4,
      child: Stack(
          children: List.generate(boardRows * boardCols, (i) {
            var col = i % boardCols;
            var row = (i / boardCols).floor();
            return Positioned(
                left: col * cellWidth,
                top: row * cellWidth,
                child: CellWidget(row: row, col: col, reFresh: reFresh),
            );
          })
      ),
    );
  }
}
