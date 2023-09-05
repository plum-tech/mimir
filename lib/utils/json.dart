import 'dart:convert';

extension JsonConverterJson2ObjEx on String {
  T? toObject<T>(T Function(Map<String, dynamic>) fromJson) {
    try {
      return fromJson(jsonDecode(this));
    } on Exception {
      return null;
    }
  }

  List<T>? toList<T>(T Function(Map<String, dynamic>) fromJson) {
    List<dynamic> list = jsonDecode(this);
    try {
      return list.map((e) => fromJson(e)).toList();
    } on Exception {
      return null;
    }
  }
}

extension JsonConverterObj2JsonEx<T> on T {
  String toJson(Map<String, dynamic> Function(T e) toJson) {
    if (this is List) {
      List<Map<String, dynamic>> list = (this as List).map((e) => toJson(e)).toList();
      return jsonEncode(list);
    } else {
      return jsonEncode(toJson(this));
    }
  }
}
