import 'dart:math';

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
      itemBuilder: (context, index) {
        final number = index + 1;
        final notedThis = note.getNoted(number);
        return Text(
          notedThis ? "$number" : "",
          textAlign: TextAlign.center,
          style: context.textTheme.labelSmall?.copyWith(
            color: cellSelected ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSurfaceVariant,
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
  final SudokuBoard board;
  final SudokuBoardZone zone;
  final int selectedIndex;
  final Widget child;

  const CellWidget({
    super.key,
    required this.cell,
    required this.board,
    required this.zone,
    required this.selectedIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colorScheme.onBackground;
    const borderRadius = Radius.circular(12);
    final edgeAgainstZone = zone.cellOnWhichEdge(cell);
    final edgeAgainstBoard = board.cellOnWhichEdge(cell);
    var innerWidth = 0.5;
    var edgeWidth = 1.5;
    const selectionWidth = 3.5;
    if (selectedIndex == cell.index) {
      edgeWidth = selectionWidth;
      innerWidth = selectionWidth;
    }
    return AnimatedContainer(
      duration: Durations.short4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: edgeAgainstBoard == null
            ? null
            : BorderRadius.only(
                topLeft: edgeAgainstBoard == Edge2D.topLeft ? borderRadius : Radius.zero,
                topRight: edgeAgainstBoard == Edge2D.topRight ? borderRadius : Radius.zero,
                bottomLeft: edgeAgainstBoard == Edge2D.bottomLeft ? borderRadius : Radius.zero,
                bottomRight: edgeAgainstBoard == Edge2D.bottomRight ? borderRadius : Radius.zero,
              ),
        color: getCellBgColor(
          cell: cell,
          board: board,
          zone: zone,
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
                  width:  edgeAgainstZone.top ? edgeWidth : innerWidth,
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

class SudokuCellArea extends StatelessWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;

  const SudokuCellArea({
    super.key,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return [
        for (var row = 0; row < 9; row++)
          [
            for (var column = 0; column < 9; column++)
              itemBuilder(
                context,
                row * 9 + column,
              ).sizedAll(min(box.maxWidth / 9, box.maxHeight / 9)),
          ].row(mas: MainAxisSize.min),
      ].column(mas: MainAxisSize.min);
    });
  }
}
