// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamEntryAdapter extends TypeAdapter<ExamEntry> {
  @override
  final int typeId = 40;

  @override
  ExamEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamEntry.legacy(
      courseName: fields[0] as String,
      place: fields[2] as String,
      campus: fields[3] as String,
      time: (fields[1] as List).cast<DateTime>(),
      seatNumber: fields[4] as int?,
      isRetake: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.courseName)
      ..writeByte(1)
      ..write(obj._timeRaw)
      ..writeByte(2)
      ..write(obj.place)
      ..writeByte(3)
      ..write(obj.campus)
      ..writeByte(4)
      ..write(obj.seatNumber)
      ..writeByte(5)
      ..write(obj.isRetake);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExamEntryAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamEntry _$ExamEntryFromJson(Map<String, dynamic> json) => ExamEntry.legacy(
      courseName: _parseCourseName(json['kcmc']),
      place: _parsePlace(json['cdmc']),
      campus: json['cdxqmc'] as String,
      time: _parseTime(json['kssj'] as String),
      seatNumber: _parseSeatNumber(json['zwh'] as String),
      isRetake: _parseRetake(json['cxbj']),
    );
