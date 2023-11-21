import 'dart:convert';

import 'package:flutter/cupertino.dart';

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
