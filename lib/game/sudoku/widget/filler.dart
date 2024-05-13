import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/board.dart';

class NumberFillerButton extends StatelessWidget {
  final int number;
  final VoidCallback? onTap;
  final Color? color;

  const NumberFillerButton({
    super.key,
    required this.number,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: onTap == null ? context.theme.disabledColor : color,
          fontWeight: FontWeight.bold,
        ),
      ).padSymmetric(h: 28, v: 16),
    );
  }
}

class NumberFillerArea extends StatelessWidget {
  final int selectedIndex;
  final SudokuBoard board;
  final bool enableFillerHint;
  final VoidCallback? Function(int number)? getOnNumberTap;

  const NumberFillerArea({
    super.key,
    required this.selectedIndex,
    required this.board,
    this.getOnNumberTap,
    this.enableFillerHint = false,
  });

  @override
  Widget build(BuildContext context) {
    final getOnNumberTap = this.getOnNumberTap;
    final relatedCells = board.relatedOf(selectedIndex).toList();
    return NumberFillerNumberPad(
      getNumberColor: (number) => !enableFillerHint
          ? null
          : relatedCells.any((cell) => cell.canUserInput ? false : cell.correctValue == number)
              ? Colors.red
              : null,
      getOnNumberTap: getOnNumberTap,
    );
  }
}

class NumberFillerNumberPad extends StatelessWidget {
  final Color? Function(int number)? getNumberColor;
  final VoidCallback? Function(int number)? getOnNumberTap;

  const NumberFillerNumberPad({
    super.key,
    this.getNumberColor,
    this.getOnNumberTap,
  });

  @override
  Widget build(BuildContext context) {
    return [
      for (var row = 0; row < 3; row++)
        [
          for (var column = 0; column < 3; column++) buildNumber(row, column),
        ].row(mas: MainAxisSize.min),
    ].column(mas: MainAxisSize.min);
  }

  Widget buildNumber(int row, int column) {
    final number = row * 3 + column + 1;
    return Card.filled(
      clipBehavior: Clip.hardEdge,
      child: NumberFillerButton(
        color: getNumberColor?.call(number),
        number: number,
        onTap: getOnNumberTap?.call(number),
      ),
    );
  }
}
