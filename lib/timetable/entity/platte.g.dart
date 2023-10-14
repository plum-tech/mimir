// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetablePalette _$TimetablePaletteFromJson(Map<String, dynamic> json) => TimetablePalette(
      name: json['name'] as String,
      colors: _colorsFromJson(json['colors'] as List),
    );

Map<String, dynamic> _$TimetablePaletteToJson(TimetablePalette instance) => <String, dynamic>{
      'name': instance.name,
      'colors': _colorsToJson(instance.colors),
    };
