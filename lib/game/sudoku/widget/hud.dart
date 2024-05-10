import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/sudoku/i18n.dart';

import '../entity/mode.dart';

class GameHudLife extends StatelessWidget {
  final int lifeCount;

  const GameHudLife({
    super.key,
    required this.lifeCount,
  });

  @override
  Widget build(BuildContext context) {
    return [
      Icon(Icons.heart_broken),
      Text(" x ${lifeCount}", style: TextStyle(fontSize: 18)),
    ].row(
      mas: MainAxisSize.min,
    );
  }
}

class GameHudHint extends StatelessWidget {
  final int hintCount;

  const GameHudHint({
    super.key,
    required this.hintCount,
  });

  @override
  Widget build(BuildContext context) {
    return [Icon(Icons.lightbulb), Text(" x ${hintCount}", style: TextStyle(fontSize: 18))].row(mas: MainAxisSize.min);
  }
}

class GameHudTimer extends StatelessWidget {
  final GameMode gameMode;
  final String time;

  const GameHudTimer({
    super.key,
    required this.gameMode,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "${gameMode.l10n()} - $time",
    );
  }
}

class GameHud extends StatelessWidget {
  final int life;
  final int hint;
  final GameMode gameMode;
  final String time;

  const GameHud({
    super.key,
    required this.life,
    required this.hint,
    required this.gameMode,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: [
        Expanded(
          flex: 1,
          child: GameHudLife(lifeCount: life).align(
            at: Alignment.centerLeft,
          ),
        ),
        // indicator
        Expanded(
          flex: 2,
          child: GameHudTimer(
            gameMode: gameMode,
            time: time,
          ).align(
            at: Alignment.center,
          ),
        ),
        // tips
        Expanded(
          flex: 1,
          child: GameHudHint(hintCount: hint).align(
            at: Alignment.centerRight,
          ),
        )
      ].row().padSymmetric(v: 8, h: 16),
    );
  }
}
