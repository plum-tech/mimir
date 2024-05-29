import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/design/entity/color2mode.dart';
import 'package:sit/utils/byte_io/byte_io.dart';

import '../../entity/timetable.dart';

part 'platte.g.dart';

DateTime _kLastModified() => DateTime.now();

@JsonSerializable()
@CopyWith()
class TimetablePalette {
  static const version = 1;
  @JsonKey()
  final String name;
  @JsonKey()
  final String author;
  @Color2ModeConverter()
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

  Uint8List encodeByteList() => _encodeByteList(this);

  static Uint8List _encodeByteList(TimetablePalette obj) {
    final writer = ByteWriter(256);
    writer.uint8(version);
    writer.strUtf8(obj.name, ByteLength.bit8);
    writer.strUtf8(obj.author, ByteLength.bit8);
    writer.uint16(obj.colors.length);
    for (var color in obj.colors) {
      writer.uint32(color.light.value);
      writer.uint32(color.dark.value);
    }

    return writer.build();
  }

  static TimetablePalette decodeFromByteList(Uint8List bytes) {
    final reader = ByteReader(bytes);
    // ignore: unused_local_variable
    final revision = reader.uint8();
    final name = reader.strUtf8(ByteLength.bit8);
    final author = reader.strUtf8(ByteLength.bit8);

    final colors = List.generate(reader.uint16(), (index) {
      Color light = Color(reader.uint32());
      Color dark = Color(reader.uint32());
      return (light: light, dark: dark);
    });

    return TimetablePalette(
      name: name,
      author: author,
      colors: colors,
      lastModified: DateTime.now(),
    );
  }
}

extension TimetablePaletteX on TimetablePalette {
  TimetablePalette markModified() {
    return copyWith(
      lastModified: DateTime.now(),
    );
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
        "colors": colors,
      };

  @override
  Uint8List encodeByteList() => TimetablePalette._encodeByteList(this);
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
