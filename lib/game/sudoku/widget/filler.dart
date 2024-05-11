import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class NumberFillerButton extends StatelessWidget {
  final int number;
  final VoidCallback? onTap;

  const NumberFillerButton({
    super.key,
    required this.number,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NumberFillerArea extends StatelessWidget {
  final VoidCallback? Function(int number)? onNumberTap;

  const NumberFillerArea({
    super.key,
    this.onNumberTap,
  });

  @override
  Widget build(BuildContext context) {
    final onNumberTap = this.onNumberTap;
    return List.generate(9, (index) => index + 1)
        .map((number) {
          return Expanded(
            flex: 1,
            child: NumberFillerButton(
              number: number,
              onTap: onNumberTap?.call(number),
            ),
          );
        })
        .toList()
        .row(mas: MainAxisSize.min);
  }
}
