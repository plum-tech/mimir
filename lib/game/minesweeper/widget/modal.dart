import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
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
    return Positioned.fill(
      child: InkWell(
        onTap: () {
          resetGame();
        },
        child: Container(
          decoration: BoxDecoration(
            color: gameOverColor.withOpacity(0.68),
          ),
          child: Text(
            i18n.gameOver,
            style: const TextStyle(
              fontSize: 64.0,
            ),
          ).center(),
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
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: goodGameColor.withOpacity(0.68),
        ),
        child: MaterialButton(
          onPressed: () {
            resetGame();
          },
          child: Text(
            "${i18n.youWin}\n${i18n.timeSpent(timer.getTimeCost())}",
            style: const TextStyle(
              fontSize: 64.0,
            ),
          ),
        ),
      ),
    );
  }
}
