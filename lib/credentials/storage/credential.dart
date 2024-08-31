import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/hive.dart';

import '../entity/credential.dart';
import '../entity/login_status.dart';

class _OaK {
  static const ns = "/oa";
  static const credentials = "$ns/credentials";
  static const lastAuthTime = "$ns/lastAuthTime";
  static const loginStatus = "$ns/loginStatus";
  static const userType = "$ns/userType";
}

class _Oa {
  final Box box;

  _Oa(this.box);

  Credentials? get credentials => box.safeGet<Credentials>(_OaK.credentials);

  set credentials(Credentials? newV) => box.safePut<Credentials>(_OaK.credentials, newV);

  late final $credentials = box.provider<Credentials>(_OaK.credentials);

  DateTime? get lastAuthTime => box.safeGet<DateTime>(_OaK.lastAuthTime);

  set lastAuthTime(DateTime? newV) => box.safePut<DateTime>(_OaK.lastAuthTime, newV);

  late final $lastAuthTime = box.provider<DateTime>(_OaK.lastAuthTime);

  LoginStatus? get loginStatus => box.safeGet<LoginStatus>(_OaK.loginStatus) ?? LoginStatus.never;

  set loginStatus(LoginStatus? newV) => box.safePut<LoginStatus>(_OaK.loginStatus, newV);

  late final $loginStatus = box.providerWithDefault<LoginStatus>(_OaK.loginStatus, () => LoginStatus.never);

  OaUserType? get userType => box.safeGet<OaUserType>(_OaK.userType);

  set userType(OaUserType? newV) => box.safePut<OaUserType>(_OaK.userType, newV);

  late final $userType = box.provider<OaUserType>(_OaK.userType);
}

class _MimirK {
  static const ns = "/mimir";
  static const loginStatus = "$ns/loginStatus";
}

class _Mimir {
  final Box box;

  _Mimir(this.box);
}

class _EmailK {
  static const ns = "/eduEmail";
  static const credentials = "$ns/credentials";
}

class _Email {
  final Box box;

  _Email(this.box);

  Credentials? get credentials => box.safeGet<Credentials>(_EmailK.credentials);

  set credentials(Credentials? newV) => box.safePut<Credentials>(_EmailK.credentials, newV);

  late final $credentials = box.provider<Credentials>(_EmailK.credentials);
}

class _LibraryK {
  static const ns = "/library";
  static const credentials = "$ns/credentials";
}

class _Library {
  final Box box;

  _Library(this.box);

  Credentials? get credentials => box.safeGet<Credentials>(_LibraryK.credentials);

  set credentials(Credentials? newV) => box.safePut<Credentials>(_LibraryK.credentials, newV);

  late final $credentials = box.provider<Credentials>(_LibraryK.credentials);
}

class CredentialStorage {
  Box get box => HiveInit.credentials;

  CredentialStorage();

  late final oa = _Oa(box);
  late final mimir = _Mimir(box);
  late final email = _Email(box);
  late final library = _Library(box);
}
