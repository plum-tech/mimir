import 'package:flutter/foundation.dart';
import 'package:mimir/hive/using.dart';

import '../entity/credential.dart';
import '../entity/email.dart';
import '../entity/login_status.dart';

class _OaKey {
  static const ns = "/oa";
  static const credential = "$ns/credential";
  static const lastAuthTime = "$ns/lastAuthTime";
  static const loginStatus = "$ns/loginStatus";
}

class _EmailKey {
  static const ns = "/eduEmail";
  static const credential = "$ns/credential";
}

class CredentialStorage {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  // OA
  OaCredential? get oaCredential => box.get(_OaKey.credential);

  set oaCredential(OaCredential? newV) => box.put(_OaKey.credential, newV);

  DateTime? get oaLastAuthTime => box.get(_OaKey.lastAuthTime);

  set oaLastAuthTime(DateTime? newV) => box.put(_OaKey.lastAuthTime, newV);

  LoginStatus? get oaLoginStatus => box.get(_OaKey.loginStatus);

  set oaLoginStatus(LoginStatus? newV) => box.put(_OaKey.loginStatus, newV);

  ValueListenable<Box<dynamic>> get onOaChanged => box.listenable(keys: [
        _OaKey.credential,
        _OaKey.lastAuthTime,
        _OaKey.loginStatus,
      ]);

  // Edu Email
  EmailCredential? get eduEmailCredential => box.get(_EmailKey.credential);

  set eduEmailCredential(EmailCredential? newV) => box.put(_EmailKey.credential, newV);

  ValueListenable<Box<dynamic>> get onEduEmailChanged => box.listenable(keys: [
        _EmailKey.credential,
      ]);
}
