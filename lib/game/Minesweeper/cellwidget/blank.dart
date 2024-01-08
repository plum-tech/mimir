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
          color: boardColor,
          child: const Icon(
            Icons.gps_fixed,
            color: mineColor,
          )
      );
    } else {
      return Container(
        width: cellWidth,
        height: cellWidth,
        color: boardColor,
        child: cell.around != 0
            ? Text(
          cell.around.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: numcolors[cell.around - 1],
              fontWeight: FontWeight.w900,
              fontSize: 28
          ),
        )
            : null,
      );
    }
  }
}
