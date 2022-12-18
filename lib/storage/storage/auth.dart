import 'package:hive/hive.dart';

import '../dao/auth.dart';

class AuthKeys {
  static const namespace = '/auth';
  static const personName = '$namespace/personName';
}

class AuthSettingStorage implements AuthSettingDao {
  final Box<dynamic> box;

  AuthSettingStorage(this.box);

  @override
  String? get personName => box.get(AuthKeys.personName);

  @override
  set personName(String? foo) => box.put(AuthKeys.personName, foo);
}
