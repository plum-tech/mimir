// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableDayLoc _$TimetableDayLocFromJson(Map<String, dynamic> json) => TimetableDayLoc(
      mode: $enumDecode(_$TimetableDayLocModeEnumMap, json['mode']),
      weekIndexInternal: (json['weekIndex'] as num?)?.toInt(),
      weekdayInternal: json['weekday'] == null ? null : Weekday.fromJson((json['weekday'] as num).toInt()),
      dateInternal: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$TimetableDayLocToJson(TimetableDayLoc instance) {
  final val = <String, dynamic>{
    'mode': _$TimetableDayLocModeEnumMap[instance.mode]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('weekIndex', instance.weekIndexInternal);
  writeNotNull('weekday', instance.weekdayInternal);
  writeNotNull('date', instance.dateInternal?.toIso8601String());
  return val;
}

const _$TimetableDayLocModeEnumMap = {
  TimetableDayLocMode.pos: 'pos',
  TimetableDayLocMode.date: 'date',
};
