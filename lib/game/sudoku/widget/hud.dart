import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/i18n.dart';
import 'package:sit/game/sudoku/i18n.dart';

import '../entity/mode.dart';
import '../page/game2.dart';

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

class GameHudTimer extends ConsumerWidget {
  final GameMode gameMode;

  const GameHudTimer({
    super.key,
    required this.gameMode,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final playTime = ref.watch(stateSudoku.select((state) => state.playtime));
    return Text(
      "${gameMode.l10n()} - ${playTime.formatPlaytime()}",
    );
  }
}

class GameHud extends StatelessWidget {
  final int? lifeCount;
  final int? hintCount;
  final GameMode gameMode;

  const GameHud({
    super.key,
    this.lifeCount,
    this.hintCount,
    required this.gameMode,
  });

  @override
  Widget build(BuildContext context) {
    final lifeCount = this.lifeCount;
    final hintCount = this.hintCount;
    return Card.filled(
      child: [
        if (lifeCount != null)
          Expanded(
            flex: 1,
            child: GameHudLife(lifeCount: lifeCount).align(
              at: Alignment.centerLeft,
            ),
          ),
        // indicator
        Expanded(
          flex: 2,
          child: GameHudTimer(
            gameMode: gameMode,
          ).align(
            at: Alignment.center,
          ),
        ),
        if (hintCount != null)
          Expanded(
            flex: 1,
            child: GameHudHint(hintCount: hintCount).align(
              at: Alignment.centerRight,
            ),
          )
      ].row().padSymmetric(v: 8, h: 16),
    );
  }
}
