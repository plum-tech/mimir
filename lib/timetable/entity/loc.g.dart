// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableDayLoc _$TimetableDayLocFromJson(Map<String, dynamic> json) => TimetableDayLoc(
      mode: $enumDecode(_$TimetableDayLocModeEnumMap, json['mode']),
      posInternal: json['pos'] == null ? null : TimetablePos.fromJson(json['pos'] as Map<String, dynamic>),
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

  writeNotNull('pos', instance.posInternal);
  writeNotNull('date', instance.dateInternal?.toIso8601String());
  return val;
}

const _$TimetableDayLocModeEnumMap = {
  TimetableDayLocMode.pos: 'pos',
  TimetableDayLocMode.date: 'date',
};
