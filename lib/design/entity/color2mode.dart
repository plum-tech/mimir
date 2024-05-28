import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rettulf/rettulf.dart';

typedef Color2Mode = ({Color light, Color dark});

extension Color2ModeX on Color2Mode {
  Color byBrightness(Brightness brightness) => brightness == Brightness.dark ? dark : light;

  Color byContext(BuildContext context) => context.isDarkMode == Brightness.dark ? dark : light;
}

int _colorToJson(Color color) => color.value;

Color _colorFromJson(int value) => Color(value);

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

class Color2ModeConverter implements JsonConverter<Color2Mode, Map> {
  const Color2ModeConverter();

  @override
  Color2Mode fromJson(Map json) => _color2ModeFromJson(json);

  @override
  Map toJson(Color2Mode object) => _color2ModeToJson(object);
}
