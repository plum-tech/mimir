import 'package:hive/hive.dart';
import 'package:version/version.dart';

import '../type_id.dart';

class VersionAdapter extends TypeAdapter<Version> {
  @override
  final int typeId = HiveTypeId.version;

  @override
  Version read(BinaryReader reader) {
    final major = reader.readInt();
    final minor = reader.readInt();
    final patch = reader.readInt();
    final build = reader.readString();
    return Version(major, minor, patch, build: build);
  }

  @override
  void write(BinaryWriter writer, Version obj) {
    writer.writeInt(obj.major);
    writer.writeInt(obj.minor);
    writer.writeInt(obj.patch);
    writer.writeString(obj.build);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VersionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
