import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/2048/storage.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Score(label: i18n.score, score: '$score'),
        const SizedBox(
          width: 8.0,
        ),
        Score(
          label: i18n.best,
          score: '$best',
        ),
      ],
    );
  }
}

class Score extends StatelessWidget {
  final String label;
  final String score;

  const Score({
    super.key,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: scoreColor,
      child: Column(children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 18.0, color: textColorWhite),
        ),
        Text(
          score,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ]).padSymmetric(h: 16, v: 8),
    );
  }
}
