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
    return ExamEntry()
      ..courseName = fields[0] as String
      ..time = (fields[1] as List).cast<DateTime>()
      ..place = fields[2] as String
      ..campus = fields[3] as String
      ..seatNumber = fields[4] as int
      ..isSecondExam = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, ExamEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.courseName)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.place)
      ..writeByte(3)
      ..write(obj.campus)
      ..writeByte(4)
      ..write(obj.seatNumber)
      ..writeByte(5)
      ..write(obj.isSecondExam);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamEntry _$ExamEntryFromJson(Map<String, dynamic> json) => ExamEntry()
  ..courseName = json['kcmc'] as String
  ..time = ExamEntry._stringToList(json['kssj'] as String)
  ..place = json['cdmc'] as String
  ..campus = json['cdxqmc'] as String
  ..seatNumber = ExamEntry._stringToInt(json['zwh'] as String)
  ..isSecondExam = json['cxbj'] as String? ?? '未知';

Map<String, dynamic> _$ExamEntryToJson(ExamEntry instance) => <String, dynamic>{
      'kcmc': instance.courseName,
      'kssj': instance.time.map((e) => e.toIso8601String()).toList(),
      'cdmc': instance.place,
      'cdxqmc': instance.campus,
      'zwh': instance.seatNumber,
      'cxbj': instance.isSecondExam,
    };
