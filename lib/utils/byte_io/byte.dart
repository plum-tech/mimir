import 'byte_length_web.dart' if (dart.library.io) 'byte_length.dart';

enum ByteLength {
  bit8(1, ByteLengths.bit8),
  bit16(2, ByteLengths.bit16),
  bit32(4, ByteLengths.bit32),
  bit64(8, ByteLengths.bit64),
  ;

  final int byteLengths;
  final int maxValue;

  const ByteLength(this.byteLengths, this.maxValue);

  @override
  String toString() => "$byteLengths-byte";
}
