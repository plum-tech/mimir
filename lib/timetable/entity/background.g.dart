// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundImage _$BackgroundImageFromJson(Map<String, dynamic> json) => BackgroundImage(
      path: json['path'] as String,
      opacity: (json['opacity'] as num).toDouble(),
    );

Map<String, dynamic> _$BackgroundImageToJson(BackgroundImage instance) => <String, dynamic>{
      'path': instance.path,
      'opacity': instance.opacity,
    };
