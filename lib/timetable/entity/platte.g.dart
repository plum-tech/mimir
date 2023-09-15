// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color2 _$Color2FromJson(Map<String, dynamic> json) => Color2(
      name: json['name'] as String?,
      light: _colorFromJson(json['light'] as int),
      dark: _colorFromJson(json['dark'] as int),
    );

Map<String, dynamic> _$Color2ToJson(Color2 instance) => <String, dynamic>{
      'name': instance.name,
      'light': _colorToJson(instance.light),
      'dark': _colorToJson(instance.dark),
    };

TimetablePlatte _$TimetablePlatteFromJson(Map<String, dynamic> json) => TimetablePlatte(
      name: json['name'] as String,
      colors: (json['colors'] as List<dynamic>).map((e) => Color2.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$TimetablePlatteToJson(TimetablePlatte instance) => <String, dynamic>{
      'name': instance.name,
      'colors': instance.colors,
    };
