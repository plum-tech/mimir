import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uri_content/uri_content.dart';

abstract class FileTypeHandlerProtocol {
  const FileTypeHandlerProtocol();

  bool matchPath(String path);

  Future<void> onHandle({
    required BuildContext context,
    required String path,
  });
}

abstract mixin class FixedExtensionMixin implements FileTypeHandlerProtocol {
  List<String> get extensions;

  @override
  bool matchPath(String path) {
    return extensions.contains(extension(path));
  }
}

final _uriContent = UriContent();

Future<Uint8List> readBytesFromUri(Uri uri) async {
  if (uri.scheme.isEmpty) {
    final fi = File(uri.toFilePath(windows: UniversalPlatform.isWindows));
    return fi.readAsBytes();
  }
  // handle file, data, and Android content.
  return _uriContent.from(uri);
}

Future<Uint8List> readBytesFromPath(String path) async {
  final uri = Uri.parse(path);
  // handle file, data, and Android content.
  return _uriContent.from(uri);
}
