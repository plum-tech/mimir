import 'package:flutter/material.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';

class CellBlank extends StatelessWidget {
  const CellBlank({super.key, required this.cell});
  final Cell cell;

  @override
  Widget build(BuildContext context) {
    if (cell.mine) {
      return Container(
          width: cellWidth,
          height: cellWidth,
          child: const Icon(
            Icons.gps_fixed,
            color: mineColor,
          )
      );
    } else {
      return Container(
        width: cellWidth,
        height: cellWidth,
        child: cell.minesAround != 0
            ? Text(
          cell.minesAround.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: numberColors[cell.minesAround - 1],
              fontWeight: FontWeight.w900,
              fontSize: 28
          ),
        )
            : null,
      );
    }
  }
}
