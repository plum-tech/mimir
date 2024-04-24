import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:universal_platform/universal_platform.dart';

Future<void> copyCompressedImageToTarget({
  required File source,
  required String target,
}) async {
  if (source.path == target) return;
  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
    FlutterImageCompress.validator.ignoreCheckExtName = true;
    await FlutterImageCompress.compressAndGetFile(
      source.path,
      target,
      format: UniversalPlatform.isIOS ? CompressFormat.heic : CompressFormat.jpeg,
    );
  } else {
    source.copy(target);
  }
}
