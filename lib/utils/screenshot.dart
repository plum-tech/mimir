import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:rettulf/rettulf.dart';
import 'package:screenshot/screenshot.dart';
import 'package:mimir/files.dart';

Future<File> takeWidgetScreenshot({
  required BuildContext context,
  required String name,
  required Widget child,
  Size? size,
}) async {
  final controller = ScreenshotController();
  final screenshot = await controller.captureFromLongWidget(
    InheritedTheme.captureAll(
      context,
      ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(size: size ?? context.mediaQuery.size),
          child: child,
        ),
      ),
    ),
    delay: const Duration(milliseconds: 100),
    context: context,
    pixelRatio: View.of(context).devicePixelRatio,
  );
  final imgFi = Files.screenshot.subFile(name);
  await imgFi.writeAsBytes(screenshot);
  return imgFi;
}

Future<void> onScreenshotTaken(String path) async {
  await OpenFile.open(path, type: "image/png");
}
