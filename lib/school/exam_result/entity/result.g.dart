// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamResultAdapter extends TypeAdapter<ExamResult> {
  @override
  final int typeId = 41;

  @override
  ExamResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResult(
      score: fields[0] as double,
      courseName: fields[1] as String,
      courseId: fields[2] as String,
      innerClassId: fields[3] as String,
      schoolYear: fields[5] as int,
      semester: fields[6] as Semester,
      credit: fields[7] as double,
      dynClassId: fields[4] as String,
      items: (fields[9] as List).cast<ExamResultItem>(),
      time: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamResult obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.courseName)
      ..writeByte(2)
      ..write(obj.courseId)
      ..writeByte(3)
      ..write(obj.innerClassId)
      ..writeByte(4)
      ..write(obj.dynClassId)
      ..writeByte(5)
      ..write(obj.schoolYear)
      ..writeByte(6)
      ..write(obj.semester)
      ..writeByte(7)
      ..write(obj.credit)
      ..writeByte(8)
      ..write(obj.time)
      ..writeByte(9)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamResultAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ExamResultItemAdapter extends TypeAdapter<ExamResultItem> {
  @override
  final int typeId = 42;

  @override
  ExamResultItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResultItem(
      fields[0] as String,
      fields[1] as String,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ExamResultItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.scoreType)
      ..writeByte(1)
      ..write(obj.percentage)
      ..writeByte(3)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamResultItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResult _$ExamResultFromJson(Map<String, dynamic> json) => ExamResult(
      score: stringToDouble(json['cj'] as String),
      courseName: _parseCourseName(json['kcmc']),
      courseId: json['kch'] as String,
      innerClassId: json['jxb_id'] as String,
      schoolYear: formFieldToSchoolYear(json['xnmmc'] as String),
      semester: formFieldToSemester(json['xqm'] as String),
      credit: stringToDouble(json['xf'] as String),
      dynClassId: json['jxbmc'] as String? ?? '',
      time: _parseTime(json['tjsj']),
    );

Map<String, dynamic> _$ExamResultToJson(ExamResult instance) => <String, dynamic>{
      'cj': instance.score,
      'kcmc': instance.courseName,
      'kch': instance.courseId,
      'jxb_id': instance.innerClassId,
      'jxbmc': instance.dynClassId,
      'xnmmc': schoolYearToFormField(instance.schoolYear),
      'xqm': _$SemesterEnumMap[instance.semester]!,
      'xf': instance.credit,
    };

const _$SemesterEnumMap = {
  Semester.all: 'all',
  Semester.term1: 'term1',
  Semester.term2: 'term2',
};
