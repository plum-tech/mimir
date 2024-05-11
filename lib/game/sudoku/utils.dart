import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';

class Matrix {
  static int getRow(int index) => index ~/ 9;

  static int getCol(int index) => index % 9;

  static int getZone(int row, int column) {
    int x = column ~/ 3;
    int y = row ~/ 3;
    return y * 3 + x;
  }

  static int getZoneByIndex(int cellIndex) {
    final row = getRow(cellIndex);
    final column = getCol(cellIndex);
    return getZone(row, column);
  }

  static int getIndex(int row, int col) => col * 9 + row;

  static List<int> getZoneIndexes({int zone = 0}) {
    List<int> indexes = [];

    // cols
    for (var col in const [0, 1, 2]) {
      // rows
      for (var row in const [0, 1, 2]) {
        indexes.add(((col + zone ~/ 3 * 3) * 9) + (row + (zone % 3) * 3));
      }
    }

    return indexes;
  }

  static List<int> getColIndexes(int col) => List.generate(9, (index) => index * 9 + col);

  static List<int> getRowIndexes(int row) => List.generate(9, (index) => row * 9 + index);
}

Color getCellBgColor({
  required BuildContext context,
  required int index,
  required int selectedIndex,
}) {
  Color gridWellBackgroundColor;
  // same zones
  List<int> zoneIndexes = Matrix.getZoneIndexes(zone: Matrix.getZoneByIndex(index));
  // same rows
  List<int> rowIndexes = Matrix.getRowIndexes(Matrix.getRow(index));
  // same columns
  List<int> colIndexes = Matrix.getColIndexes(Matrix.getCol(index));

  final indexSet = <int>{};
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
    if (Matrix.getZoneByIndex(index).isOdd) {
      gridWellBackgroundColor = context.colorScheme.surface;
    } else {
      gridWellBackgroundColor = context.colorScheme.surfaceVariant;
    }
  }
  return gridWellBackgroundColor;
}
