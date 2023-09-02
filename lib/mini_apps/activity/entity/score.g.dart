// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScScoreSummaryAdapter extends TypeAdapter<ScScoreSummary> {
  @override
  final int typeId = 302;

  @override
  ScScoreSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScScoreSummary(
      lecture: fields[0] as double,
      practice: fields[1] as double,
      creation: fields[2] as double,
      safetyEdu: fields[3] as double,
      voluntary: fields[4] as double,
      campus: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ScScoreSummary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.lecture)
      ..writeByte(1)
      ..write(obj.practice)
      ..writeByte(2)
      ..write(obj.creation)
      ..writeByte(3)
      ..write(obj.safetyEdu)
      ..writeByte(4)
      ..write(obj.voluntary)
      ..writeByte(5)
      ..write(obj.campus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScScoreSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScScoreItemAdapter extends TypeAdapter<ScScoreItem> {
  @override
  final int typeId = 304;

  @override
  ScScoreItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScScoreItem(
      fields[1] as int,
      fields[2] as ActivityType,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ScScoreItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScScoreItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScActivityApplicationAdapter extends TypeAdapter<ScActivityApplication> {
  @override
  final int typeId = 303;

  @override
  ScActivityApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScActivityApplication(
      fields[0] as int,
      fields[1] as int,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ScActivityApplication obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.applyId)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScActivityApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
