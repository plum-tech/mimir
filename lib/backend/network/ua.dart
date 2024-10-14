import 'package:dio/dio.dart';
import 'package:mimir/lifecycle.dart';
import 'package:mimir/r.dart';

class MimirUserAgentDioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["User-Agent"] = buildMimirUa();
    handler.next(options);
  }

  String buildMimirUa() {
    return _encodeMimirUa([
      "1",
      "app",
      "${R.meta.version}",
      $locale.toLanguageTag(),
      R.meta.platform.name,
      R.uuid,
    ], {
      "installer": R.meta.installerStore,
    });
  }
}

String _encodeMimirUa(List<String> fixed, Map<String, String?> kv) {
  final buffer = StringBuffer();
  for (final value in fixed) {
    buffer.write(value);
    buffer.write(";");
  }
  buffer.write("*;");
  for (final MapEntry(:key, :value) in kv.entries) {
    if (value != null) {
      buffer.write("$key=$value;");
    }
  }
  return buffer.toString();
}
