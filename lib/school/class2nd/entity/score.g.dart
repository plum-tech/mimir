// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Class2ndScoreSummaryAdapter extends TypeAdapter<Class2ndScoreSummary> {
  @override
  final int typeId = 60;

  @override
  Class2ndScoreSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndScoreSummary(
      lecture: fields[0] as double,
      practice: fields[1] as double,
      creation: fields[2] as double,
      safetyEdu: fields[3] as double,
      voluntary: fields[4] as double,
      campusCulture: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndScoreSummary obj) {
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
      ..write(obj.campusCulture);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndScoreSummaryAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class Class2ndScoreItemAdapter extends TypeAdapter<Class2ndScoreItem> {
  @override
  final int typeId = 62;

  @override
  Class2ndScoreItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndScoreItem(
      fields[1] as int,
      fields[2] as Class2ndActivityType,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndScoreItem obj) {
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
      other is Class2ndScoreItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class Class2ndActivityApplicationAdapter extends TypeAdapter<Class2ndActivityApplication> {
  @override
  final int typeId = 61;

  @override
  Class2ndActivityApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndActivityApplication(
      applyId: fields[0] as int,
      activityId: fields[1] as int,
      title: fields[2] as String,
      time: fields[3] as DateTime,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndActivityApplication obj) {
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
      other is Class2ndActivityApplicationAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
