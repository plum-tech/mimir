import 'dart:ui';

import 'package:hive/hive.dart';

import '../type_id.dart';

/// There is no need to consider revision
class SizeAdapter extends TypeAdapter<Size> {
  @override
  final int typeId = HiveTypeId.size;

  @override
  Size read(BinaryReader reader) {
    var x = reader.readDouble();
    var y = reader.readDouble();
    return Size(x, y);
  }

  @override
  void write(BinaryWriter writer, Size obj) {
    writer.writeDouble(obj.width);
    writer.writeDouble(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SizeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
