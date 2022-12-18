import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mimir/util/range.dart';

int randomInt(int start, int end) {
  return start + Random.secure().nextInt(end - start);
}

double randomDouble(double start, double end) {
  return start + (end - start) * Random.secure().nextDouble();
}

extension RandomChooseRange<T extends num> on Range<T> {
  int randomChooseInt() {
    if (start is int && end is int && step == 1) {
      return randomInt(start.toInt(), end!.toInt());
    }
    // TODO
    throw UnsupportedError('随机数工具暂不支持非整数Range的情况');
  }

  double randomChooseDouble() {
    return randomDouble(start.toDouble(), (end ?? double.maxFinite).toDouble());
  }
}

extension RandomChoose<T> on List<T> {
  T randomChooseOne([int? start, int? end]) {
    start ??= 0;
    end ??= length;
    return this[randomInt(start, end)];
  }
}

extension RandomColor on Color {
  static Color randomARGB({
    Range<int>? rangeA,
    required Range<int> rangeR,
    required Range<int> rangeG,
    required Range<int> rangeB,
  }) {
    return Color.fromARGB(
      rangeA?.randomChooseInt() ?? 255,
      rangeR.randomChooseInt(),
      rangeG.randomChooseInt(),
      rangeB.randomChooseInt(),
    );
  }

  static Color randomAHSV({
    Range<double>? rangeA,
    required Range<double> rangeH,
    Range<double>? rangeS,
    Range<double>? rangeV,
  }) {
    final one = range(1, 1);
    return HSVColor.fromAHSV(
      (rangeA ?? one).randomChooseDouble(),
      rangeH.randomChooseDouble(),
      (rangeS ?? one).randomChooseDouble(),
      (rangeV ?? one).randomChooseDouble(),
    ).toColor();
  }
}
