// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 3;

  @override
  Course read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Course(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[4] as String,
      (fields[5] as List).cast<String>(),
      fields[6] as String,
      fields[7] as double,
      fields[8] as int,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
    )
      ..weekIndex = fields[3] as int
      ..duration = fields[12] as int;
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.courseName)
      ..writeByte(1)
      ..write(obj.dayIndex)
      ..writeByte(2)
      ..write(obj.timeIndex)
      ..writeByte(11)
      ..write(obj.weekText)
      ..writeByte(3)
      ..write(obj.weekIndex)
      ..writeByte(12)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.place)
      ..writeByte(5)
      ..write(obj.teacher)
      ..writeByte(6)
      ..write(obj.campus)
      ..writeByte(7)
      ..write(obj.credit)
      ..writeByte(8)
      ..write(obj.hour)
      ..writeByte(9)
      ..write(obj.dynClassId)
      ..writeByte(10)
      ..write(obj.courseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CourseAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      json['kcmc'] as String,
      Course._day2Index(json['xqjmc'] as String),
      Course._time2Index(json['jcs'] as String),
      json['cdmc'] as String,
      json['xm'] == null ? ['空'] : Course._string2Vec(json['xm'] as String),
      json['xqmc'] as String,
      Course._string2Double(json['xf'] as String),
      Course._stringToInt(json['zxs'] as String),
      Course._trim(json['jxbmc'] as String),
      json['kch'] as String,
      json['zcd'] as String,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'kcmc': instance.courseName,
      'xqjmc': instance.dayIndex,
      'jcs': instance.timeIndex,
      'zcd': instance.weekText,
      'cdmc': instance.place,
      'xm': instance.teacher,
      'xqmc': instance.campus,
      'xf': instance.credit,
      'zxs': instance.hour,
      'jxbmc': instance.dynClassId,
      'kch': instance.courseId,
    };

CourseRaw _$CourseRawFromJson(Map<String, dynamic> json) => CourseRaw(
      json['kcmc'] as String,
      json['xqjmc'] as String,
      json['jcs'] as String,
      json['zcd'] as String,
      json['cdmc'] as String,
      json['xm'] as String? ?? '',
      json['xqmc'] as String,
      json['xf'] as String,
      json['zxs'] as String,
      json['jxbmc'] as String,
      json['kch'] as String,
    );

Map<String, dynamic> _$CourseRawToJson(CourseRaw instance) => <String, dynamic>{
      'kcmc': instance.courseName,
      'xqjmc': instance.weekDayText,
      'jcs': instance.timeslotsText,
      'zcd': instance.weekText,
      'cdmc': instance.place,
      'xm': instance.teachers,
      'xqmc': instance.campus,
      'xf': instance.courseCredit,
      'zxs': instance.creditHour,
      'jxbmc': instance.classCode,
      'kch': instance.courseCode,
    };
