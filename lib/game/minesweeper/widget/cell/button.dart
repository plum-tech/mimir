import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/entity/game_state.dart';
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
    final cellState = cell.state;
    if (cellState == CellState.blank && cell.minesAround == 0) {
      return child;
    }
    final gameState = ref.watch(minesweeperState.select((state) => state.state));
    return GestureDetector(
      onTap: (gameState == GameState.running || gameState == GameState.idle) && cellState.showCover
          ? () {
              final manager = ref.read(minesweeperState.notifier);
              // Click a Cover Cell => Blank
              if (!cellState.showFlag) {
                manager.dig(cell: cell);
                applyGameHapticFeedback();
              } else {
                // Click a Flag Cell => Cancel Flag (Covered)
                manager.removeFlag(cell: cell);
              }
            }
          : null,
      onDoubleTap: gameState == GameState.running && !cellState.showCover
          ? () {
              final manager = ref.read(minesweeperState.notifier);
              bool anyChanged = false;
              anyChanged |= manager.digAroundBesidesFlagged(cell: cell);
              anyChanged |= manager.flagRestCovered(cell: cell);
              if (anyChanged) {
                applyGameHapticFeedback();
              }
            }
          : null,
      onLongPress: gameState == GameState.running && cellState.showCover
          ? () {
              final manager = ref.read(minesweeperState.notifier);
              manager.toggleFlag(cell: cell);
              applyGameHapticFeedback();
            }
          : null,
      onSecondaryTap: gameState == GameState.running && cellState.showCover
          ? () {
              final manager = ref.read(minesweeperState.notifier);
              manager.toggleFlag(cell: cell);
              applyGameHapticFeedback();
            }
          : null,
      child: child,
    );
  }
}
