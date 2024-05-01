import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

final _codec = ZLibCodec(level: 6);
final _decoder = _codec.decoder;
final _encoder = _codec.encoder;

String encodeBytesForUrl(Uint8List original, {bool compress = true}) {
  final bytes = compress ? _encoder.convert(original) : original;
  final compressedStr = toBase64(bytes, url: true, padding: false);
  if (kDebugMode) {
    if (compress) {
      debugPrint("${original.length} => ${bytes.length}");
      assert(bytes.length <= original.length, "compressed is ${bytes.length} > original is ${original.length}");
      assert(compressedStr.length <= base64Encode(original).length);
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
