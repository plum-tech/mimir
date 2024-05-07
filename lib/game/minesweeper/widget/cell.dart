import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/cell.dart';
import '../manager/logic.dart';
import 'cell/button.dart';
import 'cell/cover.dart';
import 'cell/flag.dart';
import 'cell/mine.dart';
import 'cell/number.dart';
import '../page/game.dart';

class CellWidget extends ConsumerWidget {
  final int row;
  final int col;
  final void Function() refresh;

  const CellWidget({
    super.key,
    required this.row,
    required this.col,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(minesweeperState.notifier);
    final cell = manager.getCell(row: row, col: col);
    final bottom = buildBottom(cell);
    return Stack(
      children: [
        if (bottom != null) bottom.center(),
        Opacity(
          opacity: manager.gameOver && cell.mine ? 0.5 : 1.0,
          child: CellCover(visible: cell.state.showCover),
        ),
        CellFlag(visible: cell.state.showFlag),
        CellButton(
          cell: cell,
          coverVisible: cell.state.showCover,
          flagVisible: cell.state.showFlag,
          refresh: refresh,
        ),
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
