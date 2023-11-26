import "package:dio/dio.dart";

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
