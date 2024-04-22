import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game.dart';
import '../i18n.dart';

import '../theme.dart';

class ScoreBoard extends ConsumerWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(state2048.select((board) => board.score));
    final best = ref.watch(state2048.select((board) => board.best));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Score(label: i18n.score, score: '$score'),
        const SizedBox(
          width: 8.0,
        ),
        Score(label: i18n.best, score: '$best', padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
      ],
    );
  }
}

class Score extends StatelessWidget {
  const Score({
    super.key,
    required this.label,
    required this.score,
    this.padding,
  });

  final String label;
  final String score;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(color: scoreColor, borderRadius: BorderRadius.circular(12.0)),
      child: Column(children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 18.0, color: textColorWhite),
        ),
        Text(
          score,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ]),
    );
  }
}
