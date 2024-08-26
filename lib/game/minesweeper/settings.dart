import 'package:hive/hive.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/utils/json.dart';

import 'entity/pref.dart';

class _K {
  static const ns = "/settings";
  static const pref = '$ns/pref';
}

class SettingsMinesweeper {
  static final $ = SettingsMinesweeper._();

  Box get box => HiveInit.gameMinesweeper;

  SettingsMinesweeper._();

  /// [false] by default.
  GamePrefMinesweeper get pref =>
      decodeJsonObject(box.safeGet<String>(_K.pref), (obj) => GamePrefMinesweeper.fromJson(obj)) ??
      const GamePrefMinesweeper();

  set pref(GamePrefMinesweeper newV) => box.safePut<String>(_K.pref, encodeJsonObject(newV));

  late final $pref = box.providerWithDefault<GamePrefMinesweeper>(
    _K.pref,
    get: () => pref,
    set: (v) => pref = v,
    () => const GamePrefMinesweeper(),
  );
}
