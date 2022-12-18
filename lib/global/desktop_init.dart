import 'package:flutter/material.dart';
import 'package:mimir/r.dart';
import 'package:mimir/storage/init.dart';
import 'package:mimir/util/event_bus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

enum WindowEvent {
  onWindowResize,
  onWindowResized,
}

class MyWindowListener extends WindowListener {
  final EventBus<WindowEvent> eventBus;

  MyWindowListener({required this.eventBus});

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    eventBus.emit<Size>(WindowEvent.onWindowResize, size);
    Kv.theme.lastWindowSize = size;
  }

  @override
  void onWindowResized() async {
    final size = await windowManager.getSize();
    eventBus.emit(WindowEvent.onWindowResized);
    Kv.theme.lastWindowSize = size;
  }
}

class DesktopInit {
  static bool resizing = false;
  static EventBus<WindowEvent> eventBus = EventBus<WindowEvent>();

  static Future<void> init() async {
    windowManager.addListener(MyWindowListener(eventBus: eventBus));
    eventBus.on(WindowEvent.onWindowResize, (args) => resizing = true);
    eventBus.on(WindowEvent.onWindowResized, (args) => resizing = false);
    // 必须加上这一行。
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await DesktopInit.setTitle(R.appName);
      await windowManager.setSize(R.defaultWindowSize);
      // Center the window.
      await windowManager.center();
      await windowManager.setMinimumSize(R.minWindowSize);
      await windowManager.show();
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
