import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
    return Card.filled(
      margin: EdgeInsets.all(1),
      child: CupertinoButton(
        child: Text(
          '$number',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}

class NumberFillerArea extends StatelessWidget {
  final VoidCallback? Function(int number) onNumberTap;

  const NumberFillerArea({
    super.key,
    required this.onNumberTap,
  });

  @override
  Widget build(BuildContext context) {
    return List.generate(9, (index) => index + 1)
        .map((number) {
          return Expanded(
            flex: 1,
            child: NumberFillerButton(
              number: number,
              onTap: onNumberTap(number),
            ),
          );
        })
        .toList()
        .row(mas: MainAxisSize.min);
  }
}
