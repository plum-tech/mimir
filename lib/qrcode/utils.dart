import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hashlib_codecs/hashlib_codecs.dart';

final _codec = ZLibCodec(level: 6);
final _decoder = _codec.decoder;
final _encoder = _codec.encoder;

String encodeBytesForUrl(Uint8List bytes) {
  final compressed = _encoder.convert(bytes);
  toBase64(bytes, url: true, padding: false);
  final compressedStr = base64Encode(compressed);
  return compressedStr;
}

Uint8List decodeBytesFromUrl(String url) {
  final bytes = fromBase64(url, padding: false);
  final uncompressed = _decoder.convert(bytes);
  return uncompressed as Uint8List;
}
