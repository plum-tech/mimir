import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/board.dart';
import '../utils.dart';

class CellNotes extends StatelessWidget {
  final Set<int> notes;
  final bool cellSelected;

  const CellNotes({
    super.key,
    required this.notes,
    this.cellSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        final number = index + 1;
        final notedThis = notes.contains(number);
        return Text(
          notedThis ? "$number" : "",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: cellSelected ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        );
      },
    );
  }
}

class CellNumber extends StatelessWidget {
  final SudokuCell cell;

  CellNumber({
    required int userInput,
    required int correctValue,
  }) : this._(cell: SudokuCell(userInput: userInput, correctValue: correctValue));

  const CellNumber._({
    super.key,
    required this.cell,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      cell.isPuzzle ? "${cell.correctValue}" : (cell.emptyInput ? "" : "${cell.userInput}"),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: cell.isPuzzle ? FontWeight.w800 : FontWeight.normal,
        color: cell.isPuzzle
            ? context.colorScheme.onSurfaceVariant.withOpacity(0.5)
            : cell.isSolved
                ? context.colorScheme.onPrimaryContainer
                : Colors.red,
      ),
    );
  }
}

class CellWidget extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  final Widget child;

  const CellWidget({
    super.key,
    required this.index,
    required this.onTap,
    required this.selectedIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: getCellBgColor(
            index: index,
            selectedIndex: selectedIndex,
            context: context,
          ),
          border: Border.all(color: context.colorScheme.onBackground),
        ),
        child: child,
      ),
    );
  }
}