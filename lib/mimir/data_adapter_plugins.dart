part of 'mimir.dart';

// ignore: non_constant_identifier_names
void DefaultFlutterDataAdapterPlugin(Mimir ikite) {
  ikite._r(ColorDataAdapter());
  ikite._r(DateTimeDataAdapter());
}

extension _DataAdapterEx on Mimir {
  void _r<T>(DataAdapter<T> adapter) {
    if (!hasAdapterOf(adapter.typeName)) {
      registerAdapter(adapter);
    }
  }
}

class ColorDataAdapter extends DataAdapter<Color> {
  @override
  String get typeName => "dart.ui.Color";

  @override
  Color fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return Color(
      json["value"] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, Color obj) {
    return {"value": obj.value};
  }
}

class DateTimeDataAdapter extends DataAdapter<DateTime> {
  @override
  String get typeName => "dart.core.DateTime";

  @override
  DateTime fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return DateTime.fromMillisecondsSinceEpoch(json["millis"], isUtc: json["isUtc"]);
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, DateTime obj) {
    return {
      "millis": obj.millisecondsSinceEpoch,
      "isUtc": obj.isUtc,
    };
  }
}
