import 'package:flutter/foundation.dart';
import 'package:mimir/hive/using.dart';

import '../entity/credential.dart';
import '../entity/login_status.dart';

class _Key {
  static const ns = "/credential";
  static const oa = "$ns/oa";
  static const lastOaAuthTime = "$ns/lastOaAuthTime";
  static const loginStatus = "$ns/loginStatus";
}

class CredentialStorage {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  OACredential? get oaCredential => box.get(_Key.oa);

  set oaCredential(OACredential? newV) => box.put(_Key.oa, newV);

  DateTime? get lastOaAuthTime => box.get(_Key.lastOaAuthTime);

  set lastOaAuthTime(DateTime? newV) => box.put(_Key.lastOaAuthTime, newV);

  LoginStatus? get loginStatus => box.get(_Key.loginStatus);

  set loginStatus(LoginStatus? newV) => box.put(_Key.loginStatus, newV);

  ValueListenable<Box<dynamic>> get onAnyChanged => box.listenable();
}
