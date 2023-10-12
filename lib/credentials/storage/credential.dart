import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/credentials/entity/user_type.dart';

import '../entity/credential.dart';
import '../entity/email.dart';
import '../entity/login_status.dart';

class _OaK {
  static const ns = "/oa";
  static const credentials = "$ns/credentials";
  static const lastAuthTime = "$ns/lastAuthTime";
  static const loginStatus = "$ns/loginStatus";
  static const userType = "$ns/userType";
}

class _EmailK {
  static const ns = "/eduEmail";
  static const credentials = "$ns/credentials";
}

class CredentialStorage {
  final Box box;

  CredentialStorage(this.box);

  // OA
  OaCredentials? get oaCredentials => box.get(_OaK.credentials);

  set oaCredentials(OaCredentials? newV) => box.put(_OaK.credentials, newV);

  DateTime? get oaLastAuthTime => box.get(_OaK.lastAuthTime);

  set oaLastAuthTime(DateTime? newV) => box.put(_OaK.lastAuthTime, newV);

  LoginStatus? get oaLoginStatus => box.get(_OaK.loginStatus);

  set oaLoginStatus(LoginStatus? newV) => box.put(_OaK.loginStatus, newV);

  OaUserType? get oaUserType => box.get(_OaK.userType);

  set oaUserType(OaUserType? newV) => box.put(_OaK.userType, newV);

  ValueListenable<Box> listenOaChange() => box.listenable(keys: [
        _OaK.credentials,
        _OaK.lastAuthTime,
        _OaK.loginStatus,
        _OaK.userType,
      ]);

  // Edu Email
  EmailCredentials? get eduEmailCredentials => box.get(_EmailK.credentials);

  set eduEmailCredentials(EmailCredentials? newV) => box.put(_EmailK.credentials, newV);

  ValueListenable<Box> listenEduEmailChange() => box.listenable(keys: [
        _EmailK.credentials,
      ]);
}
