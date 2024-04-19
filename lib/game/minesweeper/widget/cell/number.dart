import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

class MinesAroundNumber extends ConsumerWidget {
  final int minesAround;

  const MinesAroundNumber({
    super.key,
    required this.minesAround,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberSize = 16 * 0.7;
    return Text(
      minesAround.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: numberColors[minesAround - 1],
        fontWeight: FontWeight.w900,
        fontSize: numberSize,
      ),
    );
  }
}
