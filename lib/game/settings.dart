import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';

class _K {
  static const ns = "/game";
  static const enableHapticFeedback = "$ns/enableHapticFeedback";
}

class GameSettings {
  final Box box;

  GameSettings(this.box);

  late final k2048 = _2048(box);

  bool get enableHapticFeedback => box.safeGet<bool>(_K.enableHapticFeedback) ?? true;

  set enableHapticFeedback(bool newV) => box.safePut<bool>(_K.enableHapticFeedback, newV);

  late final $enableHapticFeedback = box.provider<bool>(_K.enableHapticFeedback);
}

class _2048K {
  static const ns = "${_K.ns}/2048";
}

class _2048 {
  final Box box;

  const _2048(this.box);
}
