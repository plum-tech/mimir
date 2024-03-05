import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manager/logic.dart';
import '../../theme/colors.dart';

class Mine extends ConsumerWidget {
  const Mine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final cellWidth = screen.getCellWidth();
    final mineSize = cellWidth * 0.7;
    return SizedBox(
        width: cellWidth,
        height: cellWidth,
        child: Icon(
          Icons.gps_fixed,
          size: mineSize,
          color: mineColor,
        )
    );
  }
}
