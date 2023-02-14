// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyBill _$HourlyBillFromJson(Map<String, dynamic> json) => HourlyBill(
      (json['charge'] as num).toDouble(),
      (json['consumption'] as num).toDouble(),
      DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$HourlyBillToJson(HourlyBill instance) => <String, dynamic>{
      'charge': instance.charge,
      'consumption': instance.consumption,
      'time': instance.time.toIso8601String(),
    };

DailyBill _$DailyBillFromJson(Map<String, dynamic> json) => DailyBill(
      (json['charge'] as num).toDouble(),
      (json['consumption'] as num).toDouble(),
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$DailyBillToJson(DailyBill instance) => <String, dynamic>{
      'charge': instance.charge,
      'consumption': instance.consumption,
      'date': instance.date.toIso8601String(),
    };
