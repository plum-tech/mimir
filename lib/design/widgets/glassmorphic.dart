import 'dart:ui';

import 'package:flutter/widgets.dart';

class GlassmorphismBackground extends StatelessWidget {
  final double sigmaX;
  final double sigmaY;
  final List<Color> colors;

  const GlassmorphismBackground({super.key, required this.sigmaX, required this.sigmaY, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
