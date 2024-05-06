import 'package:flutter/services.dart';
import 'package:sit/settings/settings.dart';

Future<void> applyGameHapticFeedback() async {
  if (Settings.game.enableHapticFeedback) {
    await HapticFeedback.lightImpact();
  }
}
