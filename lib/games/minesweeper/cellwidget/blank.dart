import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/cellstate.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';

class CellBlank extends ConsumerWidget {
  const CellBlank({super.key, required this.cell});
  final Cell cell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final cellWidth = screen.getCellWidth();
    final numberSize = cellWidth * 0.7;
    final mineSize = cellWidth * 0.7;

    if (cell.mine) {
      return SizedBox(
          width: cellWidth,
          height: cellWidth,
          child: Icon(
            Icons.gps_fixed,
            size: mineSize,
            color: mineColor,
          )
      );
    } else {
      return SizedBox(
        width: cellWidth,
        height: cellWidth,
        child: cell.minesAround != 0
            ? Text(
          cell.minesAround.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: numberColors[cell.minesAround - 1],
              fontWeight: FontWeight.w900,
              fontSize: numberSize,
          ),
        )
            : null,
      );
    }
  }
}
