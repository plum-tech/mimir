import 'package:flutter/material.dart';

import '../../theme.dart';

class Mine extends StatelessWidget {
  const Mine({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.gps_fixed,
      size: mineSize,
      color: mineColor,
    );
  }
}
