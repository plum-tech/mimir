import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/game/entity/game_status.dart';
import 'package:mimir/game/utils.dart';
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
    final gameState = ref.watch(stateMinesweeper.select((state) => state.status));
    return GestureDetector(
      onTap: (gameState == GameStatus.running || gameState == GameStatus.idle) && cellState.showCover
          ? () {
              final manager = ref.read(stateMinesweeper.notifier);
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
      onDoubleTap: gameState == GameStatus.running && !cellState.showCover
          ? () {
              final manager = ref.read(stateMinesweeper.notifier);
              bool anyChanged = false;
              anyChanged |= manager.digAroundBesidesFlagged(cell: cell);
              anyChanged |= manager.flagRestCovered(cell: cell);
              if (anyChanged) {
                applyGameHapticFeedback();
              }
            }
          : null,
      onLongPress: gameState == GameStatus.running && cellState.showCover
          ? () {
              final manager = ref.read(stateMinesweeper.notifier);
              manager.toggleFlag(cell: cell);
              applyGameHapticFeedback();
            }
          : null,
      onSecondaryTap: gameState == GameStatus.running && cellState.showCover
          ? () {
              final manager = ref.read(stateMinesweeper.notifier);
              manager.toggleFlag(cell: cell);
              applyGameHapticFeedback();
            }
          : null,
      child: child,
    );
  }
}
