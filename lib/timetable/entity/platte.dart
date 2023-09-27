import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platte.g.dart';

int _colorToJson(Color color) => color.value;

Color _colorFromJson(int value) => Color(value);

@JsonSerializable()
class Color2Mode {
  final String? name;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color light;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color dark;

  const Color2Mode({
    this.name,
    required this.light,
    required this.dark,
  });

  factory Color2Mode.fromJson(Map<String, dynamic> json) => _$Color2ModeFromJson(json);

  Map<String, dynamic> toJson() => _$Color2ModeToJson(this);
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
  @JsonKey()
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
