import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

import '../../manager/logic.dart';
import '../../theme.dart';
import '../../page/game.dart';

class Mine extends ConsumerWidget {
  const Mine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Icon(
      Icons.gps_fixed,
      size: mineSize,
      color: mineColor,
    );
  }
}
