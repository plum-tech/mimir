import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/cell.dart';
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
    var boardWidth = screen.getBoardSize().width;
    var boardHeight = screen.getBoardSize().height;
    final portrait = context.isPortrait;
    if (!portrait) {
      (boardWidth, boardHeight) = (boardHeight, boardWidth);
    }
    final cellWidth = screen.getCellWidth();

    return SizedBox(
      width: boardWidth,
      height: boardHeight,
      child: Stack(
        children: List.generate(rows * columns, (i) {
          final row = i ~/ columns;
          final column = i % columns;
          final cell =  board.getCell(row: row, column: column);
          return Positioned(
            left: (portrait ? column : row) * cellWidth,
            top: (portrait ? row : column) * cellWidth,
            child: buildCell(cell, cellWidth),
          );
        }),
      ),
    );
  }

  Widget buildCell(Cell cell, double size) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: CellWidget(cell: cell).sizedAll(size),
    );
  }
}
