import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/json.dart';

import '../entity/bulletin.dart';

class _K {
  static const latest = "/latest";
  static const list = "/list";
}

class MimirBulletinStorage {
  Box get box => HiveInit.bulletin;

  MimirBulletinStorage();

  MimirBulletin? get latest => decodeJsonObject(
        box.safeGet<String>(_K.latest),
        (obj) => MimirBulletin.fromJson(obj),
      );

  set latest(MimirBulletin? newV) => box.safePut<String>(
        _K.latest,
        encodeJsonObject(newV),
      );
  late final $latest = box.provider(
    _K.latest,
    get: () => latest,
    set: (v) => latest = v,
  );

  List<MimirBulletin>? get list => decodeJsonList(
        box.safeGet<String>(_K.list),
        (obj) => MimirBulletin.fromJson(obj),
      );

  set list(List<MimirBulletin>? newV) => box.safePut<String>(
        _K.list,
        encodeJsonList(newV),
      );
  late final $list = box.provider(
    _K.list,
    get: () => list,
    set: (v) => list = v,
  );
}
