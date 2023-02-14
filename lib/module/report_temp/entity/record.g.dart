// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportHistoryAdapter extends TypeAdapter<ReportHistory> {
  @override
  final int typeId = 2;

  @override
  ReportHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportHistory(
      fields[0] as int,
      fields[1] as String,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReportHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.place)
      ..writeByte(2)
      ..write(obj.isNormal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportHistory _$ReportHistoryFromJson(Map<String, dynamic> json) =>
    ReportHistory(
      json['batchno'] as int,
      json['position'] as String,
      json['wendu'] as int,
    );

Map<String, dynamic> _$ReportHistoryToJson(ReportHistory instance) =>
    <String, dynamic>{
      'batchno': instance.date,
      'position': instance.place,
      'wendu': instance.isNormal,
    };
