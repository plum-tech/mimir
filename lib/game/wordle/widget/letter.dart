import 'package:flutter/material.dart';
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
        color: status.bg,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
