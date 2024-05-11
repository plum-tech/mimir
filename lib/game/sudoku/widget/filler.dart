import 'package:flutter/cupertino.dart';
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
    return CupertinoButton(
      onPressed: onTap,
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: onTap == null ? null : color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NumberFillerArea extends StatelessWidget {
  final int selectedIndex;
  final SudokuBoard board;
  final bool enableFillerHint;
  final VoidCallback? Function(int number)? onNumberTap;

  const NumberFillerArea({
    super.key,
    required this.selectedIndex,
    required this.board,
    this.onNumberTap,
    this.enableFillerHint = false,
  });

  @override
  Widget build(BuildContext context) {
    final onNumberTap = this.onNumberTap;
    final relatedCells = board.relatedOf(selectedIndex).toList();
    return List.generate(9, (index) => index + 1)
        .map((number) {
          return Expanded(
            flex: 1,
            child: NumberFillerButton(
              color: !enableFillerHint
                  ? null
                  : relatedCells.any((cell) => cell.canUserInput ? false : cell.correctValue == number)
                      ? Colors.red
                      : null,
              number: number,
              onTap: onNumberTap?.call(number),
            ),
          );
        })
        .toList()
        .row(mas: MainAxisSize.min);
  }
}
