// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dual_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorEntry _$ColorEntryFromJson(Map<String, dynamic> json) => ColorEntry(
      _colorFromJson((json['color'] as num).toInt()),
      inverseText: json['inverseText'] as bool? ?? false,
    );

Map<String, dynamic> _$ColorEntryToJson(ColorEntry instance) => <String, dynamic>{
      'color': _colorToJson(instance.color),
      'inverseText': instance.inverseText,
    };

DualColor _$DualColorFromJson(Map<String, dynamic> json) => DualColor(
      light: ColorEntry.fromJson(json['light'] as Map<String, dynamic>),
      dark: ColorEntry.fromJson(json['dark'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DualColorToJson(DualColor instance) => <String, dynamic>{
      'light': instance.light,
      'dark': instance.dark,
    };
