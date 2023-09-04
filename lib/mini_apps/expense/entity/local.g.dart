// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction()
  ..datetime = DateTime.parse(json['datetime'] as String)
  ..consumerId = json['consumerId'] as int
  ..type = $enumDecode(_$TransactionTypeEnumMap, json['type'])
  ..balanceBefore = (json['balanceBefore'] as num).toDouble()
  ..balanceAfter = (json['balanceAfter'] as num).toDouble()
  ..deltaAmount = (json['deltaAmount'] as num).toDouble()
  ..deviceName = json['deviceName'] as String
  ..note = json['note'] as String;

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'datetime': instance.datetime.toIso8601String(),
      'consumerId': instance.consumerId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'balanceBefore': instance.balanceBefore,
      'balanceAfter': instance.balanceAfter,
      'deltaAmount': instance.deltaAmount,
      'deviceName': instance.deviceName,
      'note': instance.note,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.water: 'water',
  TransactionType.shower: 'shower',
  TransactionType.food: 'food',
  TransactionType.store: 'store',
  TransactionType.topUp: 'topUp',
  TransactionType.subsidy: 'subsidy',
  TransactionType.coffee: 'coffee',
  TransactionType.library: 'library',
  TransactionType.other: 'other',
};
