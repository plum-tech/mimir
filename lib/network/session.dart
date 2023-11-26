import "package:dio/dio.dart";

class SessionOptions {
  String? method;
  Duration? sendTimeout;
  Duration? receiveTimeout;
  Map<String, dynamic>? extra;
  Map<String, dynamic>? headers;
  ResponseType? responseType;
  String? contentType;

  SessionOptions({
    this.method,
    this.sendTimeout,
    this.receiveTimeout,
    this.extra,
    this.headers,
    this.responseType,
    this.contentType,
  });
}

typedef SessionProgressCallback = void Function(int count, int total);

enum ReqMethod {
  get("GET"),
  post("POST"),
  delete("DELETE"),
  patch("PATCH"),
  update("UPDATE"),
  put("PUT");

  final String uppercaseName;

  const ReqMethod(this.uppercaseName);
}
