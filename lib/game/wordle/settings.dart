import 'package:hive/hive.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/utils/json.dart';

import 'entity/pref.dart';

class _K {
  static const ns = "/settings";
  static const pref = '$ns/pref';
}

class SettingsWordle {
  static final $ = SettingsWordle._();

  Box get box => HiveInit.gameWordle;

  SettingsWordle._();

  /// [false] by default.
  GamePrefWordle get pref =>
      decodeJsonObject(box.safeGet<String>(_K.pref), (obj) => GamePrefWordle.fromJson(obj)) ?? const GamePrefWordle();

  set pref(GamePrefWordle newV) => box.safePut<String>(_K.pref, encodeJsonObject(newV));

  late final $pref = box.providerWithDefault<GamePrefWordle>(
    _K.pref,
    get: () => pref,
    set: (v) => pref = v,
    () => const GamePrefWordle(),
  );
}
