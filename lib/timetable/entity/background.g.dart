// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundImage _$BackgroundImageFromJson(Map<String, dynamic> json) => BackgroundImage(
      path: json['path'] as String,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      repeat: json['repeat'] as bool? ?? true,
      antialias: json['antialias'] as bool? ?? true,
    );

Map<String, dynamic> _$BackgroundImageToJson(BackgroundImage instance) => <String, dynamic>{
      'path': instance.path,
      'opacity': instance.opacity,
      'repeat': instance.repeat,
      'antialias': instance.antialias,
    };
