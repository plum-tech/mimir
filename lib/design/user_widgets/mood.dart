import 'package:flutter/material.dart';

class Mood {
  static const all = [
    Icons.sentiment_satisfied_alt_rounded,
    Icons.sentiment_very_satisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_very_dissatisfied_rounded,
  ];

  static int next(int cur) => (cur + 1) % all.length;

  static int pre(int cur) => (cur - 1) % all.length;

  static IconData get(int index) => all[index % all.length];
}
