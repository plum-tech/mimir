import 'dart:convert';
import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/utils/byte_io.dart';

import 'timetable.dart';

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

DateTime _kLastModified() => DateTime.now();

@JsonSerializable()
@CopyWith()
class TimetablePalette {
  @JsonKey()
  final String name;
  @JsonKey()
  final String author;
  @JsonKey(fromJson: _colorsFromJson, toJson: _colorsToJson)
  final List<Color2Mode> colors;
  @JsonKey(defaultValue: _kLastModified)
  final DateTime lastModified;

  static const defaultColor = (light: Colors.white, dark: Colors.black);

  const TimetablePalette({
    required this.name,
    required this.author,
    required this.colors,
    required this.lastModified,
  });

  factory TimetablePalette.fromJson(Map<String, dynamic> json) => _$TimetablePaletteFromJson(json);

  Map<String, dynamic> toJson() => _$TimetablePaletteToJson(this);

  static TimetablePalette decodeFromBase64(String encoded) {
    final bytes = base64Decode(encoded);
    return decodeFromByteList(bytes);
  }

  static TimetablePalette decodeFromByteList(Uint8List bytes) {
    final reader = ByteReader(bytes);
    final name = reader.strUtf8();
    final author = reader.strUtf8();
    final colorLen = reader.uint32();

    List<Color2Mode> colors = [];
    for (int i = 0; i < colorLen; i++) {
      Color light = Color(reader.uint32());
      Color dark = Color(reader.uint32());
      colors.add((light: light, dark: dark));
    }

    return TimetablePalette(
      name: name,
      author: author,
      colors: colors,
      lastModified: DateTime.now(),
    );
  }

  List<int> encodeByteList() => _encodeByteList(this);

  static Uint8List _encodeByteList(TimetablePalette obj) {
    final writer = ByteWriter(256);
    writer.strUtf8(obj.name);
    writer.strUtf8(obj.author);
    writer.uint32(obj.colors.length);
    for (var color in obj.colors) {
      writer.uint32(color.light.value);
      writer.uint32(color.dark.value);
    }

    return writer.build();
  }
}

class BuiltinTimetablePalette implements TimetablePalette {
  final int id;
  final String key;
  final String? nameOverride;
  final String? authorOverride;

  @override
  String get name => nameOverride ?? "timetable.p13n.palette.builtin.$key.name".tr();

  @override
  String get author => authorOverride ?? "timetable.p13n.palette.builtin.$key.author".tr();
  @override
  final List<Color2Mode> colors;

  @override
  DateTime get lastModified => DateTime.now();

  const BuiltinTimetablePalette({
    required this.key,
    required this.id,
    required this.colors,
    String? name,
    String? author,
  })  : nameOverride = name,
        authorOverride = author;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "author": author,
        "colors": _colorsToJson(colors),
      };

  @override
  List<int> encodeByteList() => TimetablePalette._encodeByteList(this);
}

abstract mixin class SitTimetablePaletteResolver {
  SitTimetable get type;

  factory SitTimetablePaletteResolver(SitTimetable type) {
    return _SitTimetablePaletteResolverImpl(type: type);
  }

  final _fixedCourseCode2Color = <TimetablePalette, Map<String, Color2Mode>>{};

  Color2Mode resolveColor(TimetablePalette palette, SitCourse course) {
    assert(palette.colors.isNotEmpty, "Colors can't be empty");
    if (palette.colors.isEmpty) return TimetablePalette.defaultColor;
    assert(type.courses.containsValue(course), "Course $course not found in this timetable");

    final fixedCourseCode2Color = _fixedCourseCode2Color[palette] ?? _cacheFixedCourseCode2Color(palette);
    return fixedCourseCode2Color[course.courseCode] ??
        palette.colors[course.courseCode.hashCode.abs() % palette.colors.length];
  }

  Map<String, Color2Mode> _cacheFixedCourseCode2Color(TimetablePalette palette) {
    final queue = List.of(palette.colors);
    final fixedCourseCode2Color = <String, Color2Mode>{};
    for (final course in type.courses.values) {
      if (queue.isEmpty) break;
      final index = course.courseCode.hashCode.abs() % queue.length;
      // allocate a color for this course code
      fixedCourseCode2Color[course.courseCode] = queue[index];
      // remove it in the next loop
      queue.removeAt(index);
    }
    return fixedCourseCode2Color;
  }
}

class _SitTimetablePaletteResolverImpl with SitTimetablePaletteResolver {
  @override
  final SitTimetable type;

  _SitTimetablePaletteResolverImpl({
    required this.type,
  });
}
