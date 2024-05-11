import 'package:universal_platform/universal_platform.dart';
import 'package:vibration/vibration.dart' as vb;

abstract class VibrationProtocol {
  Future<void> emit();
}

abstract class TimedProtocol {
  int get milliseconds;
}

class Vibration implements VibrationProtocol, TimedProtocol {
  @override
  final int milliseconds;
  final int amplitude;

  const Vibration({
    this.milliseconds = 50,
    this.amplitude = -1,
  });

  @override
  Future<void> emit() async {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      if (await vb.Vibration.hasVibrator() ?? false) {
        if (await vb.Vibration.hasCustomVibrationsSupport() ?? false) {
          vb.Vibration.vibrate(duration: milliseconds, amplitude: amplitude);
        } else {
          vb.Vibration.vibrate();
        }
      }
    }
  }

  VibrationProtocol operator +(Wait wait) {
    return CompoundVibration._(timedList: [this, wait]);
  }
}

class Wait implements TimedProtocol {
  @override
  final int milliseconds;

  const Wait({this.milliseconds = 500});
}

class CompoundVibration implements VibrationProtocol {
  final List<TimedProtocol> timedList;

  CompoundVibration._({this.timedList = const []});

  @override
  Future<void> emit() async {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      if (await vb.Vibration.hasVibrator() ?? false) {
        if (await vb.Vibration.hasCustomVibrationsSupport() ?? false) {
          vb.Vibration.vibrate(pattern: timedList.map((e) => e.milliseconds).toList());
        } else {
          for (int i = 0; i < timedList.length; i++) {
            if (i % 2 == 0) {
              vb.Vibration.vibrate();
            } else {
              await Future.delayed(Duration(milliseconds: timedList[i].milliseconds));
            }
          }
        }
      }
    }
  }

  VibrationProtocol operator +(CompoundVibration other) {
    return CompoundVibration._(timedList: timedList + other.timedList);
  }
}
