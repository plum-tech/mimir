import 'dart:convert';
import 'dart:typed_data';

import 'byte.dart';

class ByteWriter {
  late ByteData _view;
  Uint8List _buffer;
  int _offset = 0;

  ByteWriter(int initialCapacity) : _buffer = Uint8List(initialCapacity) {
    _view = _buffer.buffer.asByteData();
  }

  int get size => _offset + 1;

  int get capacity => _buffer.length;

  void _checkCapacity({required int requireBytes}) {
    if (_offset + 1 + requireBytes > _buffer.length) {
      _grow(size + requireBytes);
    }
  }

  void _grow(int required) {
    // We will create a list in the range of 2-4 times larger than
    // required.
    int newSize = required * 2;
    if (newSize < _buffer.length) {
      newSize = _buffer.length;
    } else {
      newSize = _pow2roundup(newSize);
    }
    var newBuffer = Uint8List(newSize);
    newBuffer.setRange(0, _buffer.length, _buffer);
    _buffer = newBuffer;
    _view = newBuffer.buffer.asByteData();
  }

  void bytes(Uint8List bytes, [ByteLength expectedBytes = ByteLength.bit32, Endian endian = Endian.big]) {
    _minimalByteLength(bytes.length, expectedBytes);
    _buffer.setRange(_offset, _offset + bytes.length, bytes);
    _offset += bytes.length;
  }

  void _minimalByteLength(int actualBytes, [ByteLength expectedBytes = ByteLength.bit32, Endian endian = Endian.big]) {
    assert(expectedBytes.maxValue >= actualBytes, "Expect $expectedBytes but $actualBytes given");
    _checkCapacity(requireBytes: actualBytes + expectedBytes.byteLengths);
    switch (expectedBytes) {
      case ByteLength.bit8:
        uint8(actualBytes);
      case ByteLength.bit16:
        uint16(actualBytes, endian);
      case ByteLength.bit32:
        uint32(actualBytes, endian);
      case ByteLength.bit64:
        uint64(actualBytes, endian);
    }
  }

  void int8(int value) {
    _checkCapacity(requireBytes: 1);
    _view.setInt8(_offset, value);
    _offset += 1;
  }

  void int16(int value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 2);
    _view.setInt16(_offset, value, endian);
    _offset += 2;
  }

  void int32(int value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 4);
    _view.setInt32(_offset, value, endian);
    _offset += 4;
  }

  void int64(int value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 8);
    _view.setInt64(_offset, value, endian);
    _offset += 8;
  }

  void uint8(int value) {
    _checkCapacity(requireBytes: 1);
    _view.setUint8(_offset, value);
    _offset += 1;
  }

  void uint16(int value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 2);
    _view.setUint16(_offset, value, endian);
    _offset += 2;
  }

  void uint32(int value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 4);
    _view.setUint32(_offset, value, endian);
    _offset += 4;
  }

  void uint64(int value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 8);
    _view.setUint64(_offset, value, endian);
    _offset += 8;
  }

  void float32(double value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 4);
    _view.setFloat32(_offset, value, endian);
    _offset += 4;
  }

  void float64(double value, [Endian endian = Endian.big]) {
    _checkCapacity(requireBytes: 8);
    _view.setFloat64(_offset, value, endian);
    _offset += 8;
  }

  void strUtf8(String str, [ByteLength expectedBytes = ByteLength.bit32, Endian endian = Endian.big]) {
    List<int> nameBytes = utf8.encode(str);
    _minimalByteLength(nameBytes.length, expectedBytes);
    for (int i = 0; i < nameBytes.length; i++) {
      uint8(nameBytes[i]);
    }
  }

  Uint8List build() {
    return _buffer.sublist(0, _offset);
  }
}

int _pow2roundup(int x) {
  assert(x > 0);
  --x;
  x |= x >> 1;
  x |= x >> 2;
  x |= x >> 4;
  x |= x >> 8;
  x |= x >> 16;
  return x + 1;
}
