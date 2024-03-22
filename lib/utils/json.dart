import 'dart:convert';

import 'package:flutter/cupertino.dart';

T? decodeJsonObject<T>(dynamic json, T Function(dynamic obj) transform) {
  if (json == null) return null;
  try {
    if (json is String) {
      final obj = jsonDecode(json);
      return transform(obj);
    } else {
      return transform(json);
    }
  } catch (_) {
    debugPrint("Failed to decode $json");
    return null;
  }
}

String? encodeJsonObject<T>(T? obj, [dynamic Function(T obj)? transform]) {
  if (obj == null) return null;
  try {
    final json = transform != null ? transform(obj) : (obj as dynamic).toJson();
    return jsonEncode(json);
  } catch (_) {
    debugPrint("Failed to encode $json");
    return null;
  }
}

List<T>? decodeJsonList<T>(String? json, T Function(dynamic element) transform) {
  if (json == null) return null;
  try {
    final list = jsonDecode(json) as List;
    return list.map(transform).toList();
  } catch (_) {
    debugPrint("Failed to decode $json");
    return null;
  }
}

String? encodeJsonList<T>(List<T>? list, [dynamic Function(T element)? transform]) {
  if (list == null) return null;
  try {
    final json = list.map(transform ?? (e) => (e as dynamic).toJson()).toList();
    return jsonEncode(json);
  } catch (_) {
    debugPrint("Failed to encode $json");
    return null;
  }
}
