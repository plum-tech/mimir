import 'package:flutter/material.dart';
import '../../theme.dart';

class MinesAroundNumber extends StatelessWidget {
  final int minesAround;

  const MinesAroundNumber({
    super.key,
    required this.minesAround,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      minesAround.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: numberColors[minesAround - 1],
        fontWeight: FontWeight.w900,
        fontSize: numberSize,
      ),
    );
  }
}
