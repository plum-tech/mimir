import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:universal_platform/universal_platform.dart';

import 'handle.dart';
import '../qrcode/i18n.dart';

final _codec = ZLibCodec(level: 6);
final _decoder = _codec.decoder;
final _encoder = _codec.encoder;

String encodeBytesForUrl(Uint8List original, {bool compress = true}) {
  final bytes = compress ? _encoder.convert(original) : original;
  final compressedStr = toBase64(bytes, url: true, padding: false);
  if (kDebugMode) {
    if (compress) {
      debugPrint("${original.length} => ${bytes.length}");
      if (kDebugMode && !(bytes.length <= original.length)) {
        print("compressed is ${bytes.length} > original is ${original.length}");
      }
      if (kDebugMode && !(compressedStr.length <= base64Encode(original).length)) {
        print("compressed string is ${compressedStr.length} > original string is ${base64Encode(original).length}");
      }
    } else {
      debugPrint("${original.length}");
    }
  }
  return compressedStr;
}

Uint8List decodeBytesFromUrl(String url, {bool compress = true}) {
  final bytes = fromBase64(url, padding: false);
  final uncompressed = compress ? _decoder.convert(bytes) : bytes;
  return uncompressed as Uint8List;
}

Future<void> recognizeQrCode(BuildContext context) async {
  if (!(UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS ||
      UniversalPlatform.isMacOS ||
      UniversalPlatform.isWeb)) {
    return;
  }
  final res = await context.push("/tools/scanner");
  if (!context.mounted) return;
  if (Dev.on) {
    await context.showTip(desc: res.toString(), primary: i18n.ok);
  }
  if (res == null) return;
  await Future.delayed(const Duration(milliseconds: 10));
  if (!context.mounted) return;
  if (res is String) {
    final uri = Uri.tryParse(res);
    final result =
        uri == null ? DeepLinkHandleResult.invalidFormat : await onHandleDeepLink(context: context, deepLink: uri);
    if (result == DeepLinkHandleResult.success) {
      return;
    } else if (result == DeepLinkHandleResult.unhandled || result == DeepLinkHandleResult.unrelatedScheme) {
      if (!context.mounted) return;
      final maybeUri = Uri.tryParse(res);
      if (maybeUri != null) {
        await guardLaunchUrlString(context, res);
        return;
      }
      await context.showTip(desc: res.toString(), primary: i18n.ok);
    } else if (result == DeepLinkHandleResult.invalidFormat) {
      if (!context.mounted) return;
      await context.showTip(desc: i18n.invalidFormatTip, primary: i18n.ok);
    }
  } else {
    await context.showTip(desc: res.toString(), primary: i18n.ok);
  }
}
