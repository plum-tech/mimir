import 'package:flutter/material.dart';
import '../../entity/timer.dart';
import '../theme.dart';
import '../i18n.dart';

class GameStateModal extends StatelessWidget {
  final GameTimer timer;
  final void Function() resetGame;

  const GameStateModal({
    super.key,
    required this.timer,
    required this.resetGame,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: gameOverColor,
        ),
        child: MaterialButton(
          onPressed: () {
            resetGame();
          },
          child: Text(
            i18n.gameOver,
            style: TextStyle(
              color: gameOverTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

class VictoryModal extends StatelessWidget {
  final void Function() resetGame;
  final GameTimer timer;

  const VictoryModal({
    super.key,
    required this.resetGame,
    required this.timer,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: goodGameColor,
        ),
        child: MaterialButton(
          onPressed: () {
            resetGame();
          },
          child: Text(
            "${i18n.youWin}\n${i18n.timeSpent(timer.getTimeCost())}",
            style: TextStyle(color: goodGameTextColor),
          ),
        ),
      ),
    );
  }
}
