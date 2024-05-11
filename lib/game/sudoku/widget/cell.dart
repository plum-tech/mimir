import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/list2d/edge.dart';

import '../entity/board.dart';
import '../entity/note.dart';
import '../utils.dart';

class CellNotes extends StatelessWidget {
  final SudokuCellNote note;
  final bool cellSelected;

  const CellNotes({
    super.key,
    required this.note,
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
        final notedThis = note.getNoted(number);
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
  final bool cellSelected;

  const CellNumber({
    super.key,
    required this.cell,
    this.cellSelected = false,
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
            ? context.colorScheme.onSurfaceVariant
            : cell.isSolved
                ? context.colorScheme.onPrimaryContainer
                : Colors.red,
      ),
    );
  }
}

class CellWidget extends StatelessWidget {
  final SudokuCell cell;
  final Edge2D? edgeAgainstZone;
  final Edge2D? edgeAgainstBorder;
  final int selectedIndex;
  final Widget child;

  const CellWidget({
    super.key,
    required this.cell,
    required this.edgeAgainstZone,
    required this.edgeAgainstBorder,
    required this.selectedIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colorScheme.onBackground;
    const borderRadius = Radius.circular(12);
    final edgeAgainstZone = this.edgeAgainstZone;
    final edgeAgainstBorder = this.edgeAgainstBorder;
    const innerWidth = 0.15;
    const edgeWidth = 1.0;
    return AnimatedContainer(
      duration: Durations.short4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: edgeAgainstBorder == null ? null: BorderRadius.only(
          topLeft: edgeAgainstBorder == Edge2D.topLeft ? borderRadius : Radius.zero,
          topRight: edgeAgainstBorder == Edge2D.topRight ? borderRadius : Radius.zero,
          bottomLeft: edgeAgainstBorder == Edge2D.bottomLeft ? borderRadius : Radius.zero,
          bottomRight: edgeAgainstBorder == Edge2D.bottomRight ? borderRadius : Radius.zero,
        ),
        color: getCellBgColor(
          index: cell.index,
          selectedIndex: selectedIndex,
          context: context,
        ),
        border: edgeAgainstZone == null
            ? Border.all(
                color: borderColor,
                width: innerWidth,
              )
            : Border(
                top: BorderSide(
                  color: borderColor,
                  width: edgeAgainstZone.top ? edgeWidth : innerWidth,
                ),
                right: BorderSide(
                  color: borderColor,
                  width: edgeAgainstZone.right ? edgeWidth : innerWidth,
                ),
                bottom: BorderSide(
                  color: borderColor,
                  width: edgeAgainstZone.bottom ? edgeWidth : innerWidth,
                ),
                left: BorderSide(
                  color: borderColor,
                  width: edgeAgainstZone.left ? edgeWidth : innerWidth,
                ),
              ),
      ),
      child: child,
    );
  }
}
