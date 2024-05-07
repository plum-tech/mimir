import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/entity/game_state.dart';
import '../entity/cell.dart';
import 'cell/button.dart';
import 'cell/cover.dart';
import 'cell/flag.dart';
import 'cell/mine.dart';
import 'cell/number.dart';
import '../page/game.dart';

class CellWidget extends ConsumerWidget {
  final int row;
  final int col;

  const CellWidget({
    super.key,
    required this.row,
    required this.col,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(minesweeperState.notifier);
    final cell = manager.getCell(row: row, col: col);
    return CellButton(
      cell: cell,
      child: CellContent(
        cell: cell,
      ),
    );
  }
}

class CellContent extends ConsumerWidget {
  final Cell cell;

  const CellContent({
    super.key,
    required this.cell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(minesweeperState.notifier);
    final bottom = buildBottom(cell);
    return Stack(
      children: [
        if (bottom != null) bottom.center(),
        Opacity(
          opacity: manager.gameState == GameState.gameOver && cell.mine ? 0.5 : 1.0,
          child: CellCover(visible: cell.state.showCover),
        ),
        CellFlag(visible: cell.state.showFlag),
      ],
    );
  }

  Widget? buildBottom(Cell cell) {
    if (cell.mine) {
      return const Mine();
    } else if (cell.minesAround > 0) {
      return MinesAroundNumber(minesAround: cell.minesAround);
    }
    return null;
  }
}
