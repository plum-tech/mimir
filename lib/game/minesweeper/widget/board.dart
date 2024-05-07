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
    final board = ref.read(minesweeperState.select((state) => state.board));
    final rows = board.rows;
    final columns = board.columns;
    final borderWidth = screen.getBorderWidth();
    final cellWidth = screen.getCellWidth();

    return AnimatedContainer(
      width: screen.getBoardSize().width,
      height: screen.getBoardSize().height,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorScheme.onSurfaceVariant,
          width: borderWidth,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      duration: Durations.extralong4,
      child: Stack(
        children: List.generate(
          rows * columns,
          (i) {
            final row = i ~/ columns;
            final column = i % columns;
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
