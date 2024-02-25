import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import "package:flutter/foundation.dart";
import 'package:logger/logger.dart';
import '../model/cell.dart';
import '../manager/logic.dart';
import 'cell/blank.dart';
import 'cell/button.dart';
import 'cell/cover.dart';
import 'cell/flag.dart';

class CellWidget extends ConsumerWidget {
  const CellWidget({
    super.key,
    required this.row,
    required this.col,
    required this.refresh,
  });

  final void Function() refresh;
  final int row;
  final int col;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Cell cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);
    late final bool coverVisible;
    late final bool flagVisible;

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
        CellBlank(cell: cell),
        CellCover(visible: coverVisible),
        CellFlag(visible: flagVisible),
        CellButton(cell: cell, coverVisible: coverVisible, flagVisible: flagVisible, refresh: refresh),
      ],
    );
  }
}
