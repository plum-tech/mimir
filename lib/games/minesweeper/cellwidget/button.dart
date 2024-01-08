import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';

class CellButton extends ConsumerWidget {
  const CellButton({
    super.key,
    required this.cell,
    required this.coverVisible,
    required this.flagVisible,
    required this.refresh,
  });

  final Cell cell;
  final bool coverVisible;
  final bool flagVisible;
  final void Function() refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (coverVisible) {
      final manager = ref.read(boardManager.notifier);
      return SizedBox(
        width: cellWidth,
        height: cellWidth,
        child: MaterialButton(
          onPressed: () {
            // Click a Cover Cell => Blank
            if (!flagVisible) {
              manager.dig(cell: cell);
            } else {
              // Click a Flag Cell => Cancel Flag (Covered)
              manager.removeFlag(cell: cell);
            }
            refresh();
          },
          onLongPress: () {
            manager.toggleFlag(cell: cell);
            refresh();
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
