import 'package:dio/dio.dart';
import 'package:mimir/lifecycle.dart';
import 'package:mimir/r.dart';
import 'package:uuid/uuid.dart';

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
      const Uuid().v4(),
    ], {
      "installer": R.meta.installerStore,
    });
  }
}

String _encodeMimirUa(List<String> fixed, Map<String, String?> kv) {
  final list = <String>[];
  for (final value in fixed) {
    list.add(value);
  }
  list.add("*;");
  for (final MapEntry(:key, :value) in kv.entries) {
    if (value != null) {
      list.add("$key=$value");
    }
  }
  return list.join(";");
}
