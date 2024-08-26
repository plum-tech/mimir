import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/animation/number.dart';
import 'package:mimir/game/2048/storage.dart';
import '../page/game.dart';
import '../i18n.dart';

import '../theme.dart';

class ScoreBoard extends ConsumerWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(state2048.select((board) => board.score));
    var best = ref.watch(Storage2048.record.$bestScore);
    best = max(best, score);
    return [
      Score(label: i18n.score, score: score),
      const SizedBox(
        width: 8.0,
      ),
      Score(label: i18n.best, score: best),
    ].row(maa: MainAxisAlignment.center, mas: MainAxisSize.min);
  }
}

class Score extends StatelessWidget {
  final String label;
  final int score;

  const Score({
    super.key,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: scoreColor,
      child: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 18.0, color: textColorWhite),
        ),
        AnimatedNumber(
          value: score,
          duration: Durations.short3,
          builder: (ctx, score) => "${score.toInt()}".text(
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
      ].column(mas: MainAxisSize.min).padSymmetric(h: 16, v: 8),
    );
  }
}
