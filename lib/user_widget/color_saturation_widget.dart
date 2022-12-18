import 'package:flutter/material.dart';

class ColorSaturationFilteredWidget extends StatelessWidget {
  final Widget child;

  ///value [0,1]
  final double saturation;

  const ColorSaturationFilteredWidget({
    required this.child,
    this.saturation = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(_saturation(saturation)),
      child: child,
    );
  }

  List<double> get _matrix => [
        1, 0, 0, 0, 0, //R
        0, 1, 0, 0, 0, //G
        0, 0, 1, 0, 0, //B
        0, 0, 0, 1, 0, //A
      ];

  List<double> _saturation(double sat) {
    final m = _matrix;
    final double invSat = 1 - sat;
    final double R = 0.213 * invSat;
    final double G = 0.715 * invSat;
    final double B = 0.072 * invSat;
    m[0] = R + sat;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + sat;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + sat;
    return m;
  }
}
