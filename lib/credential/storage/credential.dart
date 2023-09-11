import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/credential.dart';
import '../entity/email.dart';
import '../entity/login_status.dart';

class _OaKey {
  static const ns = "/oa";
  static const credentials = "$ns/credentials";
  static const lastAuthTime = "$ns/lastAuthTime";
  static const loginStatus = "$ns/loginStatus";
}

class _EmailKey {
  static const ns = "/eduEmail";
  static const credentials = "$ns/credentials";
}

class CredentialStorage {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  // OA
  OaCredentials? get oaCredentials => box.get(_OaKey.credentials);

  set oaCredentials(OaCredentials? newV) => box.put(_OaKey.credentials, newV);

  DateTime? get oaLastAuthTime => box.get(_OaKey.lastAuthTime);

  set oaLastAuthTime(DateTime? newV) => box.put(_OaKey.lastAuthTime, newV);

  LoginStatus? get oaLoginStatus => box.get(_OaKey.loginStatus);

  set oaLoginStatus(LoginStatus? newV) => box.put(_OaKey.loginStatus, newV);

  ValueListenable<Box<dynamic>> get onOaChanged => box.listenable(keys: [
        _OaKey.credentials,
        _OaKey.lastAuthTime,
        _OaKey.loginStatus,
      ]);

  // Edu Email
  EmailCredentials? get eduEmailCredentials => box.get(_EmailKey.credentials);

  set eduEmailCredentials(EmailCredentials? newV) => box.put(_EmailKey.credentials, newV);

  ValueListenable<Box<dynamic>> get onEduEmailChanged => box.listenable(keys: [
        _EmailKey.credentials,
      ]);
}
