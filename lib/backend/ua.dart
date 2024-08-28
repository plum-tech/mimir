import 'package:mimir/r.dart';

String getMimirUa() {
  return encodeMimirUa([
    "1",
    "app",
    "${R.meta.version}",
    R.meta.platform.name,
  ], {
    "installer": R.meta.installerStore,
  });
}

String encodeMimirUa(List<String> fixed, Map<String, String?> kv) {
  final list = <String>[];
  for (final value in fixed) {
    list.add(value);
  }
  list.add("*");
  for (final MapEntry(:key, :value) in kv.entries) {
    if (value != null) {
      list.add("$key=$value");
    }
  }
  return list.join(";");
}
