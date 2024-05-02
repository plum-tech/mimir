import 'dart:typed_data';

import 'reader.dart';
import 'writer.dart';

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

int _unpackYear(int packedDate, int base) {
  return ((packedDate >> 9) & 0x1FFF) + base; // Mask to get year bits and add base
}

int _unpackMonth(int packedDate) {
  return (packedDate >> 5) & 0x1F; // Mask to get month bits
}

int _unpackDay(int packedDate) {
  return packedDate & 0x1F; // Mask to get day bits
}
