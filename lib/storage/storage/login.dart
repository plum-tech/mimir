import 'package:hive/hive.dart';

import '../dao/login.dart';

class LoginTimeKeys {
  static const namespace = '/loginTime';
  static const sso = '$namespace/sso';
}

class LoginTimeStorage implements LoginTimeDao {
  final Box<dynamic> box;

  LoginTimeStorage(this.box);

  @override
  DateTime? get sso => box.get(LoginTimeKeys.sso, defaultValue: null);

  @override
  set sso(DateTime? dateTime) => box.put(LoginTimeKeys.sso, dateTime);
}
