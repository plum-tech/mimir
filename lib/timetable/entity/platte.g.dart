// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color2Mode _$Color2ModeFromJson(Map<String, dynamic> json) => Color2Mode(
      name: json['name'] as String?,
      light: _colorFromJson(json['light'] as int),
      dark: _colorFromJson(json['dark'] as int),
    );

Map<String, dynamic> _$Color2ModeToJson(Color2Mode instance) => <String, dynamic>{
      'name': instance.name,
      'light': _colorToJson(instance.light),
      'dark': _colorToJson(instance.dark),
    };

TimetablePalette _$TimetablePaletteFromJson(Map<String, dynamic> json) => TimetablePalette(
      name: json['name'] as String,
      colors: (json['colors'] as List<dynamic>).map((e) => Color2Mode.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$TimetablePaletteToJson(TimetablePalette instance) => <String, dynamic>{
      'name': instance.name,
      'colors': instance.colors,
    };
