import 'dart:convert';
import 'dart:typed_data';
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

@JsonSerializable()
class TimetablePalette {
  @JsonKey()
  final String name;
  @JsonKey(fromJson: _colorsFromJson, toJson: _colorsToJson)
  final List<Color2Mode> colors;

  const TimetablePalette({
    required this.name,
    required this.colors,
  });

  factory TimetablePalette.fromJson(Map<String, dynamic> json) => _$TimetablePaletteFromJson(json);

  Map<String, dynamic> toJson() => _$TimetablePaletteToJson(this);

  static TimetablePalette decodeFromBase64(String encoded) {
    final bytes = base64Decode(encoded);
    return decodeFromByteList(bytes);
  }

  static decodeFromByteList(Uint8List bytes) {
    final ByteData byteData = bytes.buffer.asByteData();
    int index = 0;

    int nameLength = byteData.getUint8(index);
    index++;

    List<int> nameCodeUnits = [];
    for (int i = 0; i < nameLength; i++) {
      nameCodeUnits.add(byteData.getUint8(index));
      index++;
    }

    String name = String.fromCharCodes(nameCodeUnits);

    int colorsLength = byteData.getUint8(index);
    index++;

    List<Color2Mode> colors = [];
    for (int i = 0; i < colorsLength; i++) {
      Color light = Color(byteData.getUint32(index));
      index += 4;
      Color dark = Color(byteData.getUint32(index));
      index += 4;
      colors.add((light: light, dark: dark));
    }

    return TimetablePalette(name: name, colors: colors);
  }
}

extension TimetablePaletteX on TimetablePalette {
  TimetablePalette clone({
    String Function(String origin)? getNewName,
  }) {
    return TimetablePalette(name: getNewName?.call(name) ?? name, colors: List.of(colors));
  }

  String encodeBase64() {
    final bytes = encodeByteList();
    final encoded = base64Encode(bytes);
    return encoded;
  }

  List<int> encodeByteList() {
    final buffer = Uint8List(1024);
    final ByteData byteData = buffer.buffer.asByteData();
    int index = 0;

    byteData.setUint8(index, name.length);
    index++;

    List<int> nameBytes = utf8.encode(name);
    for (int i = 0; i < nameBytes.length; i++) {
      byteData.setUint8(index, nameBytes[i]);
      index++;
    }

    byteData.setUint8(index, colors.length);
    index++;

    for (var color in colors) {
      byteData.setUint32(index, color.light.value);
      index += 4;
      byteData.setUint32(index, color.dark.value);
      index += 4;
    }

    return buffer.sublist(0, index);
  }
}

class BuiltinTimetablePalette implements TimetablePalette {
  final int id;
  final String key;

  @override
  String get name => "timetable.p13n.builtinPalette.$key".tr();
  @override
  final List<Color2Mode> colors;

  const BuiltinTimetablePalette({
    required this.key,
    required this.id,
    required this.colors,
  });

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'colors': _colorsToJson(colors),
      };
}
