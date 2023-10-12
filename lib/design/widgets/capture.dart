import 'package:flutter/widgets.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class WidgetCaptureController {
  final GlobalKey containerKey;

  const WidgetCaptureController({
    required this.containerKey,
  });

  /// to capture widget to image by GlobalKey in RenderRepaintBoundary
  Future<Uint8List?> capture() async {
    try {
      /// boundary widget by GlobalKey
      final boundary = containerKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      /// convert boundary to image
      final image = await boundary?.toImage(pixelRatio: 6);

      /// set ImageByteFormat
      final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }
}

class WidgetCapture extends StatelessWidget {
  final Widget? child;
  final WidgetCaptureController controller;

  const WidgetCapture({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    /// to capture widget to image by GlobalKey in RepaintBoundary
    return RepaintBoundary(
      key: controller.containerKey,
      child: child,
    );
  }
}
