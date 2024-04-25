// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableLoc _$TimetableLocFromJson(Map<String, dynamic> json) => TimetableLoc(
      weekIndexInternal: (json['weekIndex'] as num?)?.toInt(),
      weekdayInternal: json['weekday'] == null ? null : Weekday.fromJson((json['weekday'] as num).toInt()),
    );

Map<String, dynamic> _$TimetableLocToJson(TimetableLoc instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('weekIndex', instance.weekIndexInternal);
  writeNotNull('weekday', instance.weekdayInternal);
  return val;
}
