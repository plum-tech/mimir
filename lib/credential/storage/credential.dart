import 'package:hive/hive.dart';

import '../dao/credential.dart';
import '../entity/credential.dart';

class _Key {
  static const ns = "/credential";
  static const oa = "$ns/oa";
  static const lastOaAuthTime = "$ns/lastOaAuthTime";
}

class CredentialStorage implements CredentialDao {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  @override
  OACredential? get oaCredential => box.get(_Key.oa);

  @override
  set oaCredential(OACredential? newV) => box.put(_Key.oa, newV);

  @override
  DateTime? get lastOaAuthTime => box.get(_Key.lastOaAuthTime);

  set lastOaAuthTime(DateTime? newV) => box.put(_Key.lastOaAuthTime, newV);
}
