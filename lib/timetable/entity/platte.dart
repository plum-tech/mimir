import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platte.g.dart';

int _colorToJson(Color color) => color.value;

Color _colorFromJson(int value) => Color(value);

typedef Color2Mode = ({Color light, Color dark});

Color2Mode _color2ModeFromJson(Map json) {
  return (
    light: _colorFromJson(json["light"]),
    dark: _colorFromJson(json["dark"]),
  );
}

Map _color2ModeToJson(Color2Mode colors) {
  return {
    "light": _colorToJson(colors.light),
    "dark": _colorToJson(colors.dark),
  };
}

List<Color2Mode> _colorsFromJson(List json) {
  return json.map((entry) => _color2ModeFromJson(entry)).toList();
}

List _colorsToJson(List<Color2Mode> colors) {
  return colors.map((entry) => _color2ModeToJson(entry)).toList();
}

abstract interface class ITimetablePalette {
  String get name;

  List<Color2Mode> get colors;
}

@JsonSerializable()
class TimetablePalette implements ITimetablePalette {
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey(fromJson: _colorsFromJson, toJson: _colorsToJson)
  final List<Color2Mode> colors;

  const TimetablePalette({
    required this.name,
    required this.colors,
  });

  factory TimetablePalette.fromJson(Map<String, dynamic> json) => _$TimetablePaletteFromJson(json);

  Map<String, dynamic> toJson() => _$TimetablePaletteToJson(this);
}

class BuiltinTimetablePalette implements ITimetablePalette {
  @override
  String get name => "timetable.platte.builtin.$id".tr();
  @override
  final List<Color2Mode> colors;
  final String id;

  const BuiltinTimetablePalette({
    required this.id,
    required this.colors,
  });
}
