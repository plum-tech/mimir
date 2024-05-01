import 'dart:io';
import 'dart:typed_data';

import 'package:hashlib_codecs/hashlib_codecs.dart';

final _codec = ZLibCodec(level: 6);
final _decoder = _codec.decoder;
final _encoder = _codec.encoder;

String encodeBytesForUrl(Uint8List bytes) {
  final compressed = _encoder.convert(bytes);
  final compressedStr = toBase64(compressed, url: true, padding: false);
  return compressedStr;
}

Uint8List decodeBytesFromUrl(String url) {
  final bytes = fromBase64(url, padding: false);
  final uncompressed = _decoder.convert(bytes);
  return uncompressed as Uint8List;
}
