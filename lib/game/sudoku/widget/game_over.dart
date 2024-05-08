import 'package:flutter/material.dart';

class AlertGameOver extends StatelessWidget {
  static bool newGame = false;
  static bool restartGame = false;

  const AlertGameOver({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'Game Over',
      ),
      content: Text(
        'You successfully solved the Sudoku',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            restartGame = true;
          },
          child: const Text('Restart Game'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            newGame = true;
          },
          child: const Text('New Game'),
        ),
      ],
    );
  }
}
