import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/json.dart';

import '../entity/info.dart';

class _K {
  static const info = "/info";
}

class FreshmanStorage {
  Box get box => HiveInit.freshman;

  FreshmanStorage();

  FreshmanInfo? get info => decodeJsonObject(
        box.safeGet<String>(_K.info),
        (obj) => FreshmanInfo.fromJson(obj),
      );

  set info(FreshmanInfo? newV) => box.safePut<String>(
        _K.info,
        encodeJsonObject(newV),
      );
  late final $info = box.provider(
    _K.info,
    get: () => info,
    set: (v) => info = v,
  );
}
