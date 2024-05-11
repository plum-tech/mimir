import 'package:collection/collection.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vibration/vibration.dart' as vb;

abstract class VibrationPattern {
  int get milliseconds;

  Future<void> emit();
}

extension VibrationPatternX on VibrationPattern {
  VibrationPattern operator +(VibrationPattern pattern) {
    return CompoundVibration._(patterns: [this, pattern]);
  }
}

class Vibration implements VibrationPattern {
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
}

class Wait implements VibrationPattern {
  @override
  final int milliseconds;

  const Wait({this.milliseconds = 500});

  @override
  Future<void> emit() async {}
}

class CompoundVibration implements VibrationPattern {
  @override
  int get milliseconds => patterns.map((p) => p.milliseconds).sum;
  final List<VibrationPattern> patterns;

  CompoundVibration._({this.patterns = const []});

  @override
  Future<void> emit() async {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      if (await vb.Vibration.hasVibrator() ?? false) {
        if (await vb.Vibration.hasCustomVibrationsSupport() ?? false) {
          vb.Vibration.vibrate(pattern: patterns.map((e) => e.milliseconds).toList());
        } else {
          for (int i = 0; i < patterns.length; i++) {
            if (i % 2 == 0) {
              vb.Vibration.vibrate();
            } else {
              await Future.delayed(Duration(milliseconds: patterns[i].milliseconds));
            }
          }
        }
      }
    }
  }

  VibrationPattern operator +(CompoundVibration other) {
    return CompoundVibration._(patterns: patterns + other.patterns);
  }
}
