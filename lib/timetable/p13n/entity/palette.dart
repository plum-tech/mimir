import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/utils/byte_io/byte_io.dart';
import 'package:uuid/uuid.dart';

import '../../entity/timetable.dart';

part 'palette.g.dart';

DateTime _kLastModified() => DateTime.now();

String _kUUid() => const Uuid().v4();

@JsonSerializable()
@CopyWith()
class TimetablePalette {
  static int maxNameLength = 50;

  /// in version 1, the [colors] is in type of [({Color light, Color dark})].
  static const version = 3;
  @JsonKey(defaultValue: _kUUid)
  final String uuid;
  @JsonKey()
  final String name;
  @JsonKey()
  final String author;
  @_DualColorMigratedFromColor2ModeConverter()
  final List<DualColor> colors;
  @JsonKey(defaultValue: _kLastModified)
  final DateTime lastModified;

  static const defaultColor = DualColor(
    light: ColorEntry(Colors.white),
    dark: ColorEntry(Colors.black),
  );

  const TimetablePalette({
    required this.uuid,
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
    writer.strUtf8(obj.uuid, ByteLength.bit8);
    writer.strUtf8(obj.name, ByteLength.bit8);
    writer.strUtf8(obj.author, ByteLength.bit8);
    writer.uint16(obj.colors.length);
    for (final color in obj.colors) {
      color.serialize(writer);
    }

    return writer.build();
  }

  static TimetablePalette decodeFromByteList(Uint8List bytes) {
    final reader = ByteReader(bytes);
    // ignore: unused_local_variable
    final revision = reader.uint8();
    final uuid = version >= 3 ? reader.strUtf8(ByteLength.bit8) : _kUUid();
    final name = reader.strUtf8(ByteLength.bit8);
    final author = reader.strUtf8(ByteLength.bit8);

    final colors = List.generate(reader.uint16(), (index) {
      if (revision == 1) {
        Color light = Color(reader.uint32());
        Color dark = Color(reader.uint32());
        return DualColor.plain(light: light, dark: dark);
      }
      return DualColor.deserialize(reader);
    });

    return TimetablePalette(
      uuid: uuid,
      name: name,
      author: author,
      colors: colors,
      lastModified: DateTime.now(),
    );
  }
}

class _DualColorMigratedFromColor2ModeConverter implements JsonConverter<DualColor, Map> {
  const _DualColorMigratedFromColor2ModeConverter();

  @override
  DualColor fromJson(Map json) {
    final light = json["light"];
    final dark = json["dark"];
    if (light is num && dark is num) {
      return DualColor.plain(
        light: Color(light.toInt()),
        dark: Color(dark.toInt()),
      );
    } else {
      return DualColor.fromJson(json.cast());
    }
  }

  @override
  Map toJson(DualColor object) => object.toJson();
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
  @override
  final String uuid;
  final String? nameOverride;
  final String? authorOverride;

  @override
  String get name => nameOverride ?? "timetable.p13n.palette.builtin.$key.name".tr();

  @override
  String get author => authorOverride ?? "timetable.p13n.palette.builtin.$key.author".tr();
  @override
  final List<DualColor> colors;

  @override
  DateTime get lastModified => DateTime.now();

  const BuiltinTimetablePalette({
    required this.key,
    required this.id,
    required this.uuid,
    required this.colors,
    String? name,
    String? author,
  })  : nameOverride = name,
        authorOverride = author;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "uuid": uuid,
        "author": author,
        "colors": colors,
      };

  @override
  Uint8List encodeByteList() => TimetablePalette._encodeByteList(this);
}

abstract mixin class TimetablePaletteResolver {
  Timetable get type;

  factory TimetablePaletteResolver(Timetable type) {
    return _TimetablePaletteResolverImpl(type: type);
  }

  final _fixedCourseCode2Color = <TimetablePalette, Map<String, DualColor>>{};

  DualColor resolveColor(TimetablePalette palette, Course course) {
    assert(palette.colors.isNotEmpty, "Colors can't be empty");
    if (palette.colors.isEmpty) return TimetablePalette.defaultColor;
    assert(type.courses.containsValue(course), "Course $course not found in this timetable");

    final fixedCourseCode2Color = _fixedCourseCode2Color[palette] ?? _cacheFixedCourseCode2Color(palette);
    return fixedCourseCode2Color[course.courseCode] ??
        palette.colors[course.courseCode.hashCode.abs() % palette.colors.length];
  }

  Map<String, DualColor> _cacheFixedCourseCode2Color(TimetablePalette palette) {
    final queue = List.of(palette.colors);
    final fixedCourseCode2Color = <String, DualColor>{};
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

class _TimetablePaletteResolverImpl with TimetablePaletteResolver {
  @override
  final Timetable type;

  _TimetablePaletteResolverImpl({
    required this.type,
  });
}
