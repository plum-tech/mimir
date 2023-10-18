// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetablePalette _$TimetablePaletteFromJson(Map<String, dynamic> json) => TimetablePalette(
      name: json['name'] as String,
      // TODO: for testing compatibility
      author: json['author'] as String? ?? "",
      colors: _colorsFromJson(json['colors'] as List),
    );

Map<String, dynamic> _$TimetablePaletteToJson(TimetablePalette instance) => <String, dynamic>{
      'name': instance.name,
      'author': instance.author,
      'colors': _colorsToJson(instance.colors),
    };
