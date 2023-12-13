// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.ug.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ExamResultUgCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ExamResultUg(...).copyWith(id: 12, name: "My name")
  /// ````
  ExamResultUg call({
    double? score,
    String? courseName,
    String? courseId,
    String? innerClassId,
    int? year,
    Semester? semester,
    double? credit,
    String? dynClassId,
    List<ExamResultItem>? items,
    DateTime? time,
    String? courseCat,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfExamResultUg.copyWith(...)`.
class _$ExamResultUgCWProxyImpl implements _$ExamResultUgCWProxy {
  const _$ExamResultUgCWProxyImpl(this._value);

  final ExamResultUg _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ExamResultUg(...).copyWith(id: 12, name: "My name")
  /// ````
  ExamResultUg call({
    Object? score = const $CopyWithPlaceholder(),
    Object? courseName = const $CopyWithPlaceholder(),
    Object? courseId = const $CopyWithPlaceholder(),
    Object? innerClassId = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
    Object? semester = const $CopyWithPlaceholder(),
    Object? credit = const $CopyWithPlaceholder(),
    Object? dynClassId = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? time = const $CopyWithPlaceholder(),
    Object? courseCat = const $CopyWithPlaceholder(),
  }) {
    return ExamResultUg(
      score: score == const $CopyWithPlaceholder() || score == null
          ? _value.score
          // ignore: cast_nullable_to_non_nullable
          : score as double,
      courseName: courseName == const $CopyWithPlaceholder() || courseName == null
          ? _value.courseName
          // ignore: cast_nullable_to_non_nullable
          : courseName as String,
      courseId: courseId == const $CopyWithPlaceholder() || courseId == null
          ? _value.courseId
          // ignore: cast_nullable_to_non_nullable
          : courseId as String,
      innerClassId: innerClassId == const $CopyWithPlaceholder() || innerClassId == null
          ? _value.innerClassId
          // ignore: cast_nullable_to_non_nullable
          : innerClassId as String,
      year: year == const $CopyWithPlaceholder() || year == null
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      semester: semester == const $CopyWithPlaceholder() || semester == null
          ? _value.semester
          // ignore: cast_nullable_to_non_nullable
          : semester as Semester,
      credit: credit == const $CopyWithPlaceholder() || credit == null
          ? _value.credit
          // ignore: cast_nullable_to_non_nullable
          : credit as double,
      dynClassId: dynClassId == const $CopyWithPlaceholder() || dynClassId == null
          ? _value.dynClassId
          // ignore: cast_nullable_to_non_nullable
          : dynClassId as String,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ExamResultItem>,
      time: time == const $CopyWithPlaceholder()
          ? _value.time
          // ignore: cast_nullable_to_non_nullable
          : time as DateTime?,
      courseCat: courseCat == const $CopyWithPlaceholder() || courseCat == null
          ? _value.courseCat
          // ignore: cast_nullable_to_non_nullable
          : courseCat as String,
    );
  }
}

extension $ExamResultUgCopyWith on ExamResultUg {
  /// Returns a callable class that can be used as follows: `instanceOfExamResultUg.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$ExamResultUgCWProxy get copyWith => _$ExamResultUgCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamResultUgAdapter extends TypeAdapter<ExamResultUg> {
  @override
  final int typeId = 20;

  @override
  ExamResultUg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResultUg(
      score: fields[0] as double,
      courseName: fields[1] as String,
      courseId: fields[2] as String,
      innerClassId: fields[3] as String,
      year: fields[5] as int,
      semester: fields[6] as Semester,
      credit: fields[7] as double,
      dynClassId: fields[4] as String,
      items: (fields[9] as List).cast<ExamResultItem>(),
      time: fields[8] as DateTime?,
      // courseCat: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExamResultUg obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.semester)
      ..writeByte(7)
      ..write(obj.credit)
      ..writeByte(8)
      ..write(obj.time)
      ..writeByte(9)
      ..write(obj.items)
      ..writeByte(10)
      ..write(obj.courseCat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamResultUgAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ExamResultItemAdapter extends TypeAdapter<ExamResultItem> {
  @override
  final int typeId = 21;

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

ExamResultUg _$ExamResultUgFromJson(Map<String, dynamic> json) => ExamResultUg(
      score: _stringToDouble(json['cj'] as String),
      courseName: _parseCourseName(json['kcmc']),
      courseId: json['kch'] as String,
      innerClassId: json['jxb_id'] as String,
      year: _formFieldToSchoolYear(json['xnmmc'] as String),
      semester: _formFieldToSemester(json['xqm'] as String),
      credit: _stringToDouble(json['xf'] as String),
      dynClassId: json['jxbmc'] as String? ?? '',
      time: _parseTime(json['tjsj']),
      courseCat: json['kclbmc'] as String,
    );

Map<String, dynamic> _$ExamResultUgToJson(ExamResultUg instance) => <String, dynamic>{
      'cj': instance.score,
      'kcmc': instance.courseName,
      'kch': instance.courseId,
      'jxb_id': instance.innerClassId,
      'jxbmc': instance.dynClassId,
      'xnmmc': _schoolYearToFormField(instance.year),
      'xqm': _$SemesterEnumMap[instance.semester]!,
      'xf': instance.credit,
      'kclbmc': instance.courseCat,
    };

const _$SemesterEnumMap = {
  Semester.all: 'all',
  Semester.term1: 'term1',
  Semester.term2: 'term2',
};
