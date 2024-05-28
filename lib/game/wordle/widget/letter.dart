import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/entity/color2mode.dart';
import 'package:sit/game/wordle/entity/status.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final LetterStatus status;

  const LetterBox({
    super.key,
    required this.letter,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: status.border,
          width: 2.0,
        ),
        color: status.bg.byContext(context),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 30,
            color: status.inverseText ? context.colorScheme.onInverseSurface : null,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
