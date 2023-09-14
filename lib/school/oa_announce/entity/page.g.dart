// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OaAnnounceListPayloadAdapter extends TypeAdapter<OaAnnounceListPayload> {
  @override
  final int typeId = 93;

  @override
  OaAnnounceListPayload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OaAnnounceListPayload(
      currentPage: fields[0] as int,
      totalPage: fields[1] as int,
      bulletinItems: (fields[2] as List).cast<OaAnnounceRecord>(),
    );
  }

  @override
  void write(BinaryWriter writer, OaAnnounceListPayload obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.currentPage)
      ..writeByte(1)
      ..write(obj.totalPage)
      ..writeByte(2)
      ..write(obj.bulletinItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OaAnnounceListPayloadAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
