import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import '../entity/cell.dart';
import '../manager/logic.dart';
import 'cell/button.dart';
import 'cell/cover.dart';
import 'cell/flag.dart';
import 'cell/mine.dart';
import 'cell/number.dart';
import '../game.dart';

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
    final manager = ref.watch(boardManager.notifier);
    final cell = manager.getCell(row: row, col: col);
    var coverVisible = true;
    var flagVisible = false;

    switch (cell.state) {
      case CellState.blank:
        coverVisible = false;
        flagVisible = false;
      case CellState.covered:
        coverVisible = true;
        flagVisible = false;
      case CellState.flag:
        coverVisible = true;
        flagVisible = true;
      default:
        if (kDebugMode) {
          logger.log(Level.error, "Wrong Cell State");
        }
    }

    return Stack(
      children: [
        if (cell.mine) const Mine() else MinesAroundNumber(cell: cell),
        Opacity(
          opacity: manager.gameOver && cell.mine ? 0.5 : 1.0,
          child: CellCover(visible: coverVisible),
        ),
        CellFlag(visible: flagVisible),
        CellButton(
          cell: cell,
          coverVisible: coverVisible,
          flagVisible: flagVisible,
          refresh: refresh,
        ),
      ],
    );
  }
}
