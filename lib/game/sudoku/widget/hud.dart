import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/i18n.dart';
import 'package:sit/game/sudoku/i18n.dart';

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
  const GameHudTimer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playTime = ref.watch(stateSudoku.select((state) => state.playtime));
    final gameMode = ref.watch(stateSudoku.select((state) => state.mode));
    return Text(
      "${gameMode.l10n()} - ${playTime.formatPlaytime()}",
    );
  }
}

class GameHud extends ConsumerWidget {
  const GameHud({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int? lifeCount = null;
    const int? hintCount = null;
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
          child: const GameHudTimer().align(
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
