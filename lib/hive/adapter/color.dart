import 'dart:ui';

import 'package:hive/hive.dart';

import '../type_id.dart';

/// There is no need to consider revision
class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = HiveTypeId.color;

  @override
  Color read(BinaryReader reader) {
    final hex = reader.readInt();
    return Color(hex);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ColorAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
