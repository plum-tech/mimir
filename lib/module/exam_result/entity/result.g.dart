// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamResultAdapter extends TypeAdapter<ExamResult> {
  @override
  final int typeId = 34;

  @override
  ExamResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResult(
      fields[0] as double,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[5] as SchoolYear,
      fields[6] as Semester,
      fields[7] as double,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExamResult obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.course)
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
      ..write(obj.credit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExamResultDetailAdapter extends TypeAdapter<ExamResultDetail> {
  @override
  final int typeId = 35;

  @override
  ExamResultDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResultDetail(
      fields[0] as String,
      fields[1] as String,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ExamResultDetail obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.scoreType)
      ..writeByte(1)
      ..write(obj.percentage)
      ..writeByte(3)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamResultDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResult _$ExamResultFromJson(Map<String, dynamic> json) => ExamResult(
      stringToDouble(json['cj'] as String),
      json['kcmc'] as String,
      json['kch'] as String,
      json['jxb_id'] as String,
      formFieldToSchoolYear(json['xnmmc'] as String),
      formFieldToSemester(json['xqm'] as String),
      stringToDouble(json['xf'] as String),
      json['jxbmc'] as String? ?? '无',
    );

Map<String, dynamic> _$ExamResultToJson(ExamResult instance) =>
    <String, dynamic>{
      'cj': instance.value,
      'kcmc': instance.course,
      'kch': instance.courseId,
      'jxb_id': instance.innerClassId,
      'jxbmc': instance.dynClassId,
      'xnmmc': schoolYearToFormField(instance.schoolYear),
      'xqm': _$SemesterEnumMap[instance.semester]!,
      'xf': instance.credit,
    };

const _$SemesterEnumMap = {
  Semester.all: 'all',
  Semester.term1: 'term1st',
  Semester.term2: 'term2rd',
};
