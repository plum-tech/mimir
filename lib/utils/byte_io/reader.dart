import 'dart:convert';
import 'dart:typed_data';

import 'byte.dart';

class ByteReader {
  final Uint8List data;
  late final ByteData _view;
  int _offset = 0;

  ByteReader(this.data) {
    _view = data.buffer.asByteData();
  }

  Uint8List bytes([ByteLength expectedBytes = ByteLength.bit32]) {
    final length = _minimalByteLength(expectedBytes);
    final bytes = Uint8List.sublistView(data, _offset, _offset + length);
    _offset += bytes.length;
    return bytes;
  }

  int _minimalByteLength(ByteLength expectedBytes) {
    return switch (expectedBytes) {
      ByteLength.bit8 => uint8(),
      ByteLength.bit16 => uint16(),
      ByteLength.bit32 => uint32(),
      ByteLength.bit64 => uint64(),
    };
  }

  int int8() {
    final value = _view.getInt8(_offset);
    _offset += 1;
    return value;
  }

  int int16([Endian endian = Endian.big]) {
    final value = _view.getInt16(_offset, endian);
    _offset += 2;
    return value;
  }

  int int32([Endian endian = Endian.big]) {
    final value = _view.getInt32(_offset, endian);
    _offset += 4;
    return value;
  }

  int int64([Endian endian = Endian.big]) {
    final value = _view.getInt64(_offset, endian);
    _offset += 8;
    return value;
  }

  int uint8() {
    final value = _view.getUint8(_offset);
    _offset += 1;
    return value;
  }

  int uint16([Endian endian = Endian.big]) {
    final value = _view.getUint16(_offset, endian);
    _offset += 2;
    return value;
  }

  int uint32([Endian endian = Endian.big]) {
    final value = _view.getUint32(_offset, endian);
    _offset += 4;
    return value;
  }

  int uint64([Endian endian = Endian.big]) {
    final value = _view.getUint64(_offset, endian);
    _offset += 8;
    return value;
  }

  double float32([Endian endian = Endian.big]) {
    final value = _view.getFloat32(_offset, endian);
    _offset += 4;
    return value;
  }

  double float64([Endian endian = Endian.big]) {
    final value = _view.getFloat64(_offset, endian);
    _offset += 8;
    return value;
  }

  String strUtf8([ByteLength expectedBytes = ByteLength.bit32, Endian endian = Endian.big]) {
    final length = _minimalByteLength(expectedBytes);
    List<int> charCodes = [];
    for (int i = 0; i < length; i++) {
      final code = uint8();
      charCodes.add(code);
    }
    return utf8.decode(charCodes);
  }
}
