import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../manager/timer.dart';
import '../manager/logic.dart';
import 'cell.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key, required this.refresh, required this.timer});
  final void Function() refresh;
  final GameTimer timer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final boardRows = ref.read(boardManager).mode.gameRows;
    final boardCols = ref.read(boardManager).mode.gameCols;
    final borderWidth = screen.getBorderWidth();
    final cellWidth = screen.getCellWidth();
    final boardRadius = screen.getBoardRadius();

    return AnimatedContainer(
      width: screen.getBoardSize().width,
      height: screen.getBoardSize().height,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorScheme.onSurfaceVariant,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(boardRadius),
        ),
      ),
      duration: Durations.extralong4,
      child: Stack(
          children: List.generate(boardRows * boardCols, (i) {
        var col = i % boardCols;
        var row = (i / boardCols).floor();
        return Positioned(
          left: col * cellWidth,
          top: row * cellWidth,
          child: CellWidget(row: row, col: col, refresh: refresh),
        );
      })),
    );
  }
}
