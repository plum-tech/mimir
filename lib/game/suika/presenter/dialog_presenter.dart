import 'package:flutter/material.dart';
import 'package:sit/route.dart';
import '../domain/game_state.dart';
import 'package:get_it/get_it.dart';

class DialogPresenter {
  Future<void> showGameOverDialog(int score) async {
    return showDialog<void>(
      context: $Key.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                GetIt.I.get<GameState>().reset();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }
}
