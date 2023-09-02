import 'package:flutter/foundation.dart';
import 'package:mimir/hive/using.dart';

import '../entity/credential.dart';

class _Key {
  static const ns = "/credential";
  static const oa = "$ns/oa";
  static const lastOaAuthTime = "$ns/lastOaAuthTime";
}

class CredentialStorage {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  OACredential? get oaCredential => box.get(_Key.oa);

  set oaCredential(OACredential? newV) => box.put(_Key.oa, newV);

  DateTime? get lastOaAuthTime => box.get(_Key.lastOaAuthTime);

  set lastOaAuthTime(DateTime? newV) => box.put(_Key.lastOaAuthTime, newV);

  ValueListenable<Box<dynamic>> get $OaCredential => box.listenable(keys: [_Key.oa]);

  ValueListenable<Box<dynamic>> get $LastOaAuthTime => box.listenable(keys: [_Key.lastOaAuthTime]);
}
