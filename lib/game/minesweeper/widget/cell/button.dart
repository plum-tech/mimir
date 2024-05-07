import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/utils.dart';
import '../../entity/cell.dart';
import '../../page/game.dart';

class CellButton extends ConsumerWidget {
  const CellButton({
    super.key,
    required this.cell,
    required this.child,
  });

  final Cell cell;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(minesweeperState.notifier);
    final state = cell.state;
    if (state == CellState.blank && cell.minesAround == 0) {
      return child;
    }
    return GestureDetector(
      onTap: !state.showCover
          ? null
          : () {
              // Click a Cover Cell => Blank
              if (!state.showFlag) {
                manager.dig(cell: cell);
                applyGameHapticFeedback();
              } else {
                // Click a Flag Cell => Cancel Flag (Covered)
                manager.removeFlag(cell: cell);
              }
            },
      onDoubleTap: state.showCover
          ? null
          : () {
              bool anyChanged = false;
              anyChanged |= manager.digAroundBesidesFlagged(cell: cell);
              anyChanged |= manager.flagRestCovered(cell: cell);
              if (anyChanged) {
                applyGameHapticFeedback();
              }
            },
      onLongPress: !state.showCover
          ? null
          : () {
              manager.toggleFlag(cell: cell);
              applyGameHapticFeedback();
            },
      onSecondaryTap: !state.showCover
          ? null
          : () {
              manager.toggleFlag(cell: cell);
              applyGameHapticFeedback();
            },
      child: child,
    );
  }
}
