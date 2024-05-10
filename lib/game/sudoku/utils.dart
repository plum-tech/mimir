import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

/// 计算网格背景色
Color getCellBgColor({
  required BuildContext context,
  required int index,
  required int selectedIndex,
}) {
  Color gridWellBackgroundColor;
  // same zones
  List<int> zoneIndexes = Matrix.getZoneIndexes(zone: Matrix.getZone(index: index));
  // same rows
  List<int> rowIndexes = Matrix.getRowIndexes(Matrix.getRow(index));
  // same columns
  List<int> colIndexes = Matrix.getColIndexes(Matrix.getCol(index));

  Set indexSet = Set();
  indexSet.addAll(zoneIndexes);
  indexSet.addAll(rowIndexes);
  indexSet.addAll(colIndexes);

  if (index == selectedIndex) {
    // the cell was selected
    gridWellBackgroundColor = context.colorScheme.primaryContainer;
  } else if (indexSet.contains(selectedIndex)) {
    // the cell is involved
    gridWellBackgroundColor = context.colorScheme.tertiaryContainer;
  } else {
    // others
    if (Matrix.getZone(index: index).isOdd) {
      gridWellBackgroundColor = context.colorScheme.surface;
    } else {
      gridWellBackgroundColor = context.colorScheme.surfaceVariant;
    }
  }
  return gridWellBackgroundColor;
}
