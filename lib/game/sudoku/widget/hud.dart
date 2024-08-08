import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

import '../page/game.dart';
import '../i18n.dart';

class GameHudMistake extends StatelessWidget {
  final int mistakes;
  final int maxMistakes;

  const GameHudMistake({
    super.key,
    required this.mistakes,
    required this.maxMistakes,
  });

  @override
  Widget build(BuildContext context) {
    return [
      const Icon(Icons.heart_broken),
      Text("$mistakes / $maxMistakes", style: const TextStyle(fontSize: 18)),
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
    return [
      const Icon(Icons.lightbulb),
      Text(" x $hintCount", style: const TextStyle(fontSize: 18)),
    ].row(mas: MainAxisSize.min);
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
      "${gameMode.l10n()} - ${i18n.formatPlaytime(playTime)}",
    );
  }
}

class GameHud extends ConsumerWidget {
  const GameHud({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int? mistakeCount = null;
    const int? hintCount = null;
    return Card.filled(
      child: [
        if (mistakeCount != null)
          Expanded(
            flex: 1,
            child: GameHudMistake(
              mistakes: mistakeCount,
              maxMistakes: 3,
            ).align(
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
