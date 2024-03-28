import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/hive.dart';

import '../entity/credential.dart';
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

class _LibraryK {
  static const ns = "/library";
  static const credentials = "$ns/credentials";
}

class CredentialStorage {
  Box get box => HiveInit.credentials;

  CredentialStorage();

  // OA
  Credentials? get oaCredentials => box.safeGet(_OaK.credentials);

  set oaCredentials(Credentials? newV) => box.safePut(_OaK.credentials, newV);

  DateTime? get oaLastAuthTime => box.safeGet(_OaK.lastAuthTime);

  set oaLastAuthTime(DateTime? newV) => box.safePut(_OaK.lastAuthTime, newV);

  LoginStatus? get oaLoginStatus => box.safeGet(_OaK.loginStatus);

  set oaLoginStatus(LoginStatus? newV) => box.safePut(_OaK.loginStatus, newV);

  OaUserType? get oaUserType => box.safeGet(_OaK.userType);

  set oaUserType(OaUserType? newV) => box.safePut(_OaK.userType, newV);

  ValueListenable<Box> listenOaChange() => box.listenable(keys: [
        _OaK.credentials,
        _OaK.lastAuthTime,
        _OaK.loginStatus,
        _OaK.userType,
      ]);

  // Edu Email
  Credentials? get eduEmailCredentials => box.safeGet(_EmailK.credentials);

  set eduEmailCredentials(Credentials? newV) => box.safePut(_EmailK.credentials, newV);

  ValueListenable<Box> listenEduEmailChange() => box.listenable(keys: [
        _EmailK.credentials,
      ]);

  // Library
  Credentials? get libraryCredentials => box.safeGet(_LibraryK.credentials);

  set libraryCredentials(Credentials? newV) => box.safePut(_LibraryK.credentials, newV);

  ValueListenable<Box> listenLibraryChange() => box.listenable(keys: [
        _LibraryK.credentials,
      ]);

  late final $libraryCredentials = box.provider<Credentials>(_LibraryK.credentials);
}
