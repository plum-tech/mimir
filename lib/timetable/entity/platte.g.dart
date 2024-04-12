// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetablePalette _$TimetablePaletteFromJson(Map<String, dynamic> json) => TimetablePalette(
      name: json['name'] as String,
      author: json['author'] as String,
      colors: _colorsFromJson(json['colors'] as List),
      lastModified: json['lastModified'] == null ? _kLastModified() : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$TimetablePaletteToJson(TimetablePalette instance) => <String, dynamic>{
      'name': instance.name,
      'author': instance.author,
      'colors': _colorsToJson(instance.colors),
      'lastModified': instance.lastModified.toIso8601String(),
    };
