// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveWordle _$SaveWordleFromJson(Map<String, dynamic> json) => SaveWordle(
      playtime: Duration(microseconds: (json['playtime'] as num).toInt()),
    );

Map<String, dynamic> _$SaveWordleToJson(SaveWordle instance) => <String, dynamic>{
      'playtime': instance.playtime.inMicroseconds,
    };
