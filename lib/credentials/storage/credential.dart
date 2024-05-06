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
  Credentials? get oaCredentials => box.safeGet<Credentials>(_OaK.credentials);

  set oaCredentials(Credentials? newV) => box.safePut<Credentials>(_OaK.credentials, newV);

  late final $oaCredentials = box.provider<Credentials>(_OaK.credentials);

  DateTime? get oaLastAuthTime => box.safeGet<DateTime>(_OaK.lastAuthTime);

  set oaLastAuthTime(DateTime? newV) => box.safePut<DateTime>(_OaK.lastAuthTime, newV);

  late final $oaLastAuthTime = box.provider<DateTime>(_OaK.lastAuthTime);

  LoginStatus? get oaLoginStatus => box.safeGet<LoginStatus>(_OaK.loginStatus) ?? LoginStatus.never;

  set oaLoginStatus(LoginStatus? newV) => box.safePut<LoginStatus>(_OaK.loginStatus, newV);

  late final $oaLoginStatus = box.providerWithDefault<LoginStatus>(_OaK.loginStatus, () => LoginStatus.never);

  OaUserType? get oaUserType => box.safeGet<OaUserType>(_OaK.userType);

  set oaUserType(OaUserType? newV) => box.safePut<OaUserType>(_OaK.userType, newV);

  late final $oaUserType = box.provider<OaUserType>(_OaK.userType);

  // Edu Email
  Credentials? get eduEmailCredentials => box.safeGet<Credentials>(_EmailK.credentials);

  set eduEmailCredentials(Credentials? newV) => box.safePut<Credentials>(_EmailK.credentials, newV);

  late final $eduEmailCredentials = box.provider<Credentials>(_EmailK.credentials);

  // Library
  Credentials? get libraryCredentials => box.safeGet<Credentials>(_LibraryK.credentials);

  set libraryCredentials(Credentials? newV) => box.safePut<Credentials>(_LibraryK.credentials, newV);

  late final $libraryCredentials = box.provider<Credentials>(_LibraryK.credentials);
}
