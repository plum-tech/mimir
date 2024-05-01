import 'dart:convert';
import 'dart:typed_data';

enum ByteLength {
  bit8(1, 0xFF),
  bit16(2, 0xFFFF),
  bit32(4, 0xFFFFFFFF),
  bit64(8, 0xFFFFFFFFFFFFFFFF),
  ;

  final int byteLengths;
  final int maxValue;

  const ByteLength(this.byteLengths, this.maxValue);

  @override
  String toString() => "$byteLengths-byte";
}

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
    assert(expectedBytes.maxValue >= actualBytes, "Expect $expectedBytes");
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

extension ByteWriterX on ByteWriter {
  void b(bool v) {
    uint8(v ? 1 : 0);
  }

  /// only for year, month, and day.
  void datePacked(DateTime date, int base, [Endian endian = Endian.big]) {
    uint16(_packDate(date, base), endian);
  }

  /// for milliseconds precision
  void dateMilli(DateTime date, [Endian endian = Endian.big]) {
    uint32(date.millisecondsSinceEpoch, endian);
  }

  /// for microseconds precision
  void dateMicro(DateTime date, [Endian endian = Endian.big]) {
    uint64(date.microsecondsSinceEpoch, endian);
  }
}

/// Assuming valid year (e.g., 2000-2099), month (1-12), and day (1-31)
int _packDate(DateTime date, int base) {
  return (date.year - base) << 9 | (date.month << 5) | date.day;
}

int _unpackYear(int packedDate, int base) {
  return ((packedDate >> 9) & 0x1FFF) + base; // Mask to get year bits and add base
}

int _unpackMonth(int packedDate) {
  return (packedDate >> 5) & 0x1F; // Mask to get month bits
}

int _unpackDay(int packedDate) {
  return packedDate & 0x1F; // Mask to get day bits
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

extension ByteReaderX on ByteReader {
  bool b() {
    return uint8() != 0;
  }

  /// only for year, month, and day.
  DateTime datePacked(int base) {
    final packed = uint16();
    return DateTime(
      _unpackYear(packed, base),
      _unpackMonth(packed),
      _unpackDay(packed),
    );
  }

  /// for milliseconds precision
  DateTime dateMilli([Endian endian = Endian.big]) {
    return DateTime.fromMillisecondsSinceEpoch(uint32(endian));
  }

  /// for microseconds precision
  DateTime dateMicro([Endian endian = Endian.big]) {
    return DateTime.fromMicrosecondsSinceEpoch(uint64(endian));
  }
}
