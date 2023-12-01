import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sit/r.dart';
import 'package:sit/storage/prefs.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowListener extends WindowListener {
  @override
  void onWindowResized() {
    super.onWindowResized();
    saveWindowSize();
  }

  Future<void> saveWindowSize() async {
    final prefs = await SharedPreferences.getInstance();
    final curSize = await windowManager.getSize();
    await prefs.setLastWindowSize(curSize);
    debugPrint("Saved last window size $curSize");
  }
}

class DesktopInit {
  static Future<void> init({
    Size? size,
  }) async {
    if (!UniversalPlatform.isDesktop) return;
    windowManager.addListener(DesktopWindowListener());
    await windowManager.ensureInitialized();
    final options = WindowOptions(
      title: R.appName,
      size: size ?? R.defaultWindowSize,
      center: true,
      minimumSize: R.minWindowSize,
    );
    windowManager.waitUntilReadyToShow(options).then((_) async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  static Future<void> resizeTo(Size newSize, {bool center = true}) async {
    await windowManager.setSize(newSize);
    if (center) {
      await windowManager.center();
    }
  }

  static setTitle(String title) async {
    if (UniversalPlatform.isDesktop) {
      await windowManager.setTitle(title);
    }
  }
}
