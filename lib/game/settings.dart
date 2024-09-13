import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/utils/hive.dart';

class _K {
  static const ns = "/game";
  static const enableHapticFeedback = "$ns/enableHapticFeedback";
  static const showGameNavigation = "$ns/showGameNavigation";
}

class GameSettings {
  final Box box;

  GameSettings(this.box);

  bool get enableHapticFeedback => box.safeGet<bool>(_K.enableHapticFeedback) ?? true;

  set enableHapticFeedback(bool newV) => box.safePut<bool>(_K.enableHapticFeedback, newV);

  late final $enableHapticFeedback = box.provider<bool>(_K.enableHapticFeedback);

  bool get showGameNavigation => box.safeGet<bool>(_K.showGameNavigation) ?? true;

  set showGameNavigation(bool newV) => box.safePut<bool>(_K.showGameNavigation, newV);

  late final $showGameNavigation = box.providerWithDefault<bool>(_K.showGameNavigation, () => true);
}
