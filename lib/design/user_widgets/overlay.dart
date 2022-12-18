import 'package:flutter/widgets.dart';

mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  // 2
  OverlayEntry? _overlayEntry;

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void insertOverlay(Widget child) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (_) => child,
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }
}
