class SessionRes<T> {
  T data;
  Uri realUri;

  SessionRes({
    required this.data,
    required this.realUri,
  });
}

enum SessionResType { json, stream, plain, bytes }

class HeaderConstants {
  static const jsonContentType = 'application/json; charset=utf-8';
  static const formUrlEncodedContentType = 'application/x-www-form-urlencoded;charset=utf-8';
  static const textPlainContentType = 'text/plain';
}

class SessionOptions {
  String? method;
  int? sendTimeout;
  int? receiveTimeout;
  Map<String, dynamic>? extra;
  Map<String, dynamic>? headers;
  SessionResType? responseType;
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

abstract class ISession {
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    dynamic data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  });
}
