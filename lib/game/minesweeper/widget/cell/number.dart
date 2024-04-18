import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manager/logic.dart';
import '../../entity/cell.dart';
import '../../theme.dart';
import '../../game.dart';

class MinesAroundNumber extends ConsumerWidget {
  final Cell cell;

  const MinesAroundNumber({
    super.key,
    required this.cell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final cellWidth = screen.getCellWidth();
    final numberSize = cellWidth * 0.7;
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
