import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/settings.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

enum WindowEvent {
  onWindowResize,
  onWindowResized,
}

class WindowResizeEvent {
  final Size size;

  const WindowResizeEvent(this.size);
}

class WindowResizeEndEvent {
  final Size finalSize;

  const WindowResizeEndEvent(this.finalSize);
}

final EventBus desktopEventBus = EventBus();

class DesktopWindowListener extends WindowListener {
  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    desktopEventBus.fire(WindowResizeEvent(size));
    Settings.lastWindowSize = size;
  }

  @override
  void onWindowResized() async {
    final size = await windowManager.getSize();
    desktopEventBus.fire(WindowResizeEndEvent(size));
    Settings.lastWindowSize = size;
  }
}

class DesktopInit {
  static bool resizing = false;

  static Future<void> init() async {
    // TODO: multiple windows listener
    windowManager.addListener(DesktopWindowListener());
    desktopEventBus.on<WindowResizeEvent>().listen((e) {
      resizing = true;
    });
    desktopEventBus.on<WindowResizeEndEvent>().listen((e) {
      resizing = false;
    });
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
