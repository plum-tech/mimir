import 'package:flutter/material.dart';
import 'package:sit/design/entity/dual_color.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: status.border,
          width: 2.0,
        ),
        color: status.bg.colorBy(context),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 30,
            color: status.bg.textColorBy(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
