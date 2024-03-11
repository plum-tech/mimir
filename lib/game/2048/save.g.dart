// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Save2048 _$Save2048FromJson(Map<String, dynamic> json) => Save2048(
      score: json['score'] as int? ?? 0,
      tiles: (json['tiles'] as List<dynamic>?)?.map((e) => e as int).toList() ?? _defaultTiles(),
    );

Map<String, dynamic> _$Save2048ToJson(Save2048 instance) => <String, dynamic>{
      'score': instance.score,
      'tiles': instance.tiles,
    };
