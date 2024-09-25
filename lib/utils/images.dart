import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:path/path.dart' as path;

bool isGif(File imageFile){
  return  path.extension(imageFile.path).toLowerCase() == ".gif";
}

Future<void> copyCompressedImageToTarget({
  required File source,
  required String target,
  bool compressGif = false,
}) async {
  if (source.path == target) return;
  final supportCompress = UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isMacOS;
  if (!supportCompress) {
    await source.copy(target);
    return;
  }
  if (!isGif(source) || compressGif) {
    FlutterImageCompress.validator.ignoreCheckExtName = true;
    await FlutterImageCompress.compressAndGetFile(
      source.path,
      target,
      format: UniversalPlatform.isIOS ? CompressFormat.heic : CompressFormat.png,
    );
    return;
  } else {
    await source.copy(target);
  }
}

Future<File?> cropImage(BuildContext context, File imageFile) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    compressFormat: ImageCompressFormat.png,
    uiSettings: [
      AndroidUiSettings(
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
        ],
      ),
      IOSUiSettings(
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
        ],
      ),
    ],
  );
  if (croppedFile == null) return null;
  return File(croppedFile.path);
}
