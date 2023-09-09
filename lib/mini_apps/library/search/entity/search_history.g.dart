// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibrarySearchHistoryItemAdapter extends TypeAdapter<LibrarySearchHistoryItem> {
  @override
  final int typeId = 0;

  @override
  LibrarySearchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibrarySearchHistoryItem()
      ..keyword = fields[0] as String
      ..time = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, LibrarySearchHistoryItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.keyword)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibrarySearchHistoryItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
