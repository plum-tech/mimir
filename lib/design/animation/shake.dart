import 'dart:ui';

import 'package:flutter_shake_animated/flutter_shake_animated.dart';

final allLittleShaking = [
  LittleShaking1(),
  LittleShaking2(),
  ShakeLittleConstant1(),
  ShakeLittleConstant2(),
];

class LittleShaking1 implements ShakeConstant {
  @override
  List<int> get interval => [3, 4, 5];

  @override
  List<double> get opacity => const [];

  @override
  List<double> get rotate => const [
        0,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0
      ];

  @override
  List<Offset> get translate => const [
        Offset(0, 0),
        Offset(1, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 0),
        Offset(1, 0),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 0),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0),
        Offset(0, 0),
        Offset(0, 0),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0)
      ];

  @override
  Duration get duration => const Duration(milliseconds: 100);
}

class LittleShaking2 implements ShakeConstant {
  @override
  List<int> get interval => [5, 5, 4, 3];

  @override
  List<double> get opacity => const [];

  @override
  List<double> get rotate => const [
        0,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0
      ];

  @override
  List<Offset> get translate => const [
        Offset(0, 0),
        Offset(1, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0),
        Offset(0, 0),
        Offset(0, 0),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0)
      ];

  @override
  Duration get duration => const Duration(milliseconds: 120);
}
