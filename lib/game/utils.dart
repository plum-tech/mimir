import 'package:flutter/services.dart';
import 'package:sit/settings/settings.dart';

enum HapticFeedbackIntensity {
  light,
  medium,
  heavy,
  ;
}

Future<void> applyGameHapticFeedback([HapticFeedbackIntensity intensity = HapticFeedbackIntensity.light]) async {
  if (!Settings.game.enableHapticFeedback) return;
  switch (intensity) {
    case HapticFeedbackIntensity.light:
      await HapticFeedback.lightImpact();
      break;
    case HapticFeedbackIntensity.medium:
      await HapticFeedback.mediumImpact();
      break;
    case HapticFeedbackIntensity.heavy:
      await HapticFeedback.heavyImpact();
      // await const Vibration(milliseconds: 200, amplitude: 127).emit();
      break;
  }
}
