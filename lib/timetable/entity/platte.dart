import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platte.g.dart';

int _colorToJson(Color color) => color.value;

Color _colorFromJson(int value) => Color(value);

@JsonSerializable()
class Color2 {
  final String? name;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color light;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color dark;

  const Color2({
    this.name,
    required this.light,
    required this.dark,
  });

  factory Color2.fromJson(Map<String, dynamic> json) => _$Color2FromJson(json);

  Map<String, dynamic> toJson() => _$Color2ToJson(this);
}

abstract interface class ITimetablePlatte {
  String get name;

  List<Color2> get colors;
}

@JsonSerializable()
class TimetablePlatte implements ITimetablePlatte {
  @JsonKey()
  final String name;
  @JsonKey()
  final List<Color2> colors;

  const TimetablePlatte({
    required this.name,
    required this.colors,
  });

  factory TimetablePlatte.fromJson(Map<String, dynamic> json) => _$TimetablePlatteFromJson(json);

  Map<String, dynamic> toJson() => _$TimetablePlatteToJson(this);
}

class BuiltinTimetablePlatte implements ITimetablePlatte {
  @override
  String get name => "timetable.platte.builtin.$id".tr();
  @override
  final List<Color2> colors;
  final String id;

  const BuiltinTimetablePlatte({
    required this.id,
    required this.colors,
  });
}
