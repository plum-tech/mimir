import 'package:sit/utils/hive.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';

class HiveCookieJar implements Storage {
  final Box box;

  const HiveCookieJar(this.box);

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}

  @override
  Future<void> write(String key, String value) async => box.safePut<String>(key, value);

  @override
  Future<String?> read(String key) async => box.safeGet<String>(key);

  @override
  Future<void> delete(String key) async => box.delete(key);

  @override
  Future<void> deleteAll(List<String> keys) async => box.deleteAll(keys);
}
