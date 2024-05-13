import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/screen.dart';
import 'cell.dart';
import '../page/game.dart';

class GameBoard extends ConsumerWidget {
  final Screen screen;

  const GameBoard({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.read(stateMinesweeper.select((state) => state.board));
    final rows = board.rows;
    final columns = board.columns;
    final borderWidth = screen.getBorderWidth();
    var boardWidth= screen.getBoardSize().width;
    var boardHeight= screen.getBoardSize().height;
    final portrait = context.isPortrait;
    if (!portrait) {
      (boardWidth, boardHeight) = (boardHeight, boardWidth);
    }
    final cellWidth = screen.getCellWidth();

    return AnimatedContainer(
      width: boardWidth,
      height: boardHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorScheme.onSurfaceVariant,
          width: borderWidth,
        ),
      ),
      duration: Durations.extralong4,
      child: Stack(
        children: List.generate(
          rows * columns,
          (i) {
            var row = i ~/ columns;
            var column = i % columns;
            if (!portrait) {
              (column, row) = (row, column);
            }
            return Positioned(
              left: column * cellWidth,
              top: row * cellWidth,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: CellWidget(
                  cell: board.getCell(row: row, column: column),
                ).sizedAll(cellWidth),
              ),
            );
          },
        ),
      ),
    );
  }
}
