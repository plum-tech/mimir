import 'package:sit/game/storage/record.dart';
import 'package:sit/game/storage/save.dart';
import 'package:sit/storage/hive/init.dart';

import 'entity/record.dart';
import 'entity/save.dart';
import 'r.dart';

class Storage2048 {
  static const _ns = "/${R2048.name}/${R2048.version}";
  static final save = GameSaveStorage<Save2048>(
    () => HiveInit.game2048,
    prefix: _ns,
    serialize: (save) => save.toJson(),
    deserialize: Save2048.fromJson,
  );
  static final record = GameRecordStorage<Record2048>(
    () => HiveInit.game2048,
    prefix: _ns,
    serialize: (record) => record.toJson(),
    deserialize: Record2048.fromJson,
  );
}
