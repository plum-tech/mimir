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
  final selectedZoneIndex = SudokuBoardZone.getZoneIndexByIndex(selectedIndex);
  if (selectedZoneIndex == zone.zoneIndex ||
      _isTheSameRow(index, selectedIndex) ||
      _isTheSameColumn(index, selectedIndex)) {
    return context.colorScheme.tertiaryContainer;
  }
  final selectedCell = board.getCellByIndex(selectedIndex);
  if (_isTheSameNumber(cell, selectedCell)) {
    return context.colorScheme.secondaryContainer;
  }

  return zone.zoneIndex.isOdd ? context.colorScheme.surface : context.colorScheme.surfaceVariant;
}

bool _isTheSameRow(int a, int b) => SudokuBoard.getRowFrom(a) == SudokuBoard.getRowFrom(b);

bool _isTheSameColumn(int a, int b) => SudokuBoard.getColumnFrom(a) == SudokuBoard.getColumnFrom(b);

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
