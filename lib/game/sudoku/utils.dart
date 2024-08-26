import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/sudoku/entity/board.dart';

Color getCellBgColor({
  required BuildContext context,
  required SudokuBoard board,
  required SudokuBoardZone zone,
  required SudokuCell cell,
  required int selectedIndex,
}) {
  final index = cell.index;
  // current cell is selected
  if (index == selectedIndex) {
    return context.colorScheme.primaryContainer;
  }
  if (isRelated(index, selectedIndex)) {
    return context.colorScheme.secondaryContainer;
  }
  final selectedCell = board.getCellByIndex(selectedIndex);
  if (isTheSameNumber(cell, selectedCell)) {
    return context.colorScheme.tertiaryContainer;
  }

  // return context.colorScheme.surface;
  return zone.zoneIndex.isOdd
      ? context.colorScheme.surface
      : context.colorScheme.surfaceContainerHighest.withOpacity(0.5);
}

bool isRelated(int indexA, int indexB) {
  return SudokuBoardZone.getZoneIndexByIndex(indexA) == SudokuBoardZone.getZoneIndexByIndex(indexB) ||
      _isTheSameRow(indexA, indexB) ||
      _isTheSameColumn(indexA, indexB);
}

bool _isTheSameRow(int indexA, int indexB) => SudokuBoard.getRowFrom(indexA) == SudokuBoard.getRowFrom(indexB);

bool _isTheSameColumn(int indexA, int indexB) => SudokuBoard.getColumnFrom(indexA) == SudokuBoard.getColumnFrom(indexB);

bool isTheSameNumber(SudokuCell a, SudokuCell b) {
  if (a.canUserInput && a.emptyInput) return false;
  if (b.canUserInput && b.emptyInput) return false;
  if (a.canUserInput && b.canUserInput) {
    return a.userInput == b.userInput;
  }
  if (!a.canUserInput && !b.canUserInput) {
    return a.correctValue == b.correctValue;
  }
  final puzzle = !a.canUserInput ? a : b;
  final need2Fill = puzzle == a ? b : a;
  return need2Fill.userInput == puzzle.correctValue;
}
