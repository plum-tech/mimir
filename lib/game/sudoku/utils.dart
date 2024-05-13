import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/sudoku/entity/board.dart';

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
  if (_isTheSameNumber(cell, selectedCell)) {
    return context.colorScheme.tertiaryContainer;
  }

  return zone.zoneIndex.isOdd ? context.colorScheme.surface : context.colorScheme.surfaceVariant;
}

bool isRelated(int indexA, int indexB) {
  return SudokuBoardZone.getZoneIndexByIndex(indexA) == SudokuBoardZone.getZoneIndexByIndex(indexB) ||
      _isTheSameRow(indexA, indexB) ||
      _isTheSameColumn(indexA, indexB);
}

bool _isTheSameRow(int indexA, int indexB) => SudokuBoard.getRowFrom(indexA) == SudokuBoard.getRowFrom(indexB);

bool _isTheSameColumn(int indexA, int indexB) => SudokuBoard.getColumnFrom(indexA) == SudokuBoard.getColumnFrom(indexB);

bool _isTheSameNumber(SudokuCell a, SudokuCell b) {
  if (a.canUserInput) {
    if (b.userInput != SudokuCell.emptyInputNumber) {
      if (b.canUserInput && a.userInput == b.userInput) {
        return true;
      } else if (b.correctValue == a.userInput) {
        return true;
      }
    }
  } else {
    // selected cell is a puzzle
    if (b.canUserInput) {
      if (a.correctValue == b.userInput) {
        return true;
      }
    } else if (b.correctValue == a.correctValue) {
      // cell is a puzzle
      return true;
    }
  }
  return false;
}
