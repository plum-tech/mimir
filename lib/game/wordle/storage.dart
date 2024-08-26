import 'package:mimir/game/storage/record.dart';
import 'package:mimir/game/storage/save.dart';
import 'package:mimir/storage/hive/init.dart';

import 'entity/record.dart';
import 'entity/save.dart';
import 'r.dart';

class StorageWordle {
  static const _ns = "/${RWordle.name}/${RWordle.version}";
  static final save = GameSaveStorage<SaveWordle>(
    () => HiveInit.gameWordle,
    prefix: _ns,
    serialize: (save) => save.toJson(),
    deserialize: SaveWordle.fromJson,
  );
  static final record = GameRecordStorage<RecordWordle>(
    () => HiveInit.gameWordle,
    prefix: _ns,
    serialize: (record) => record.toJson(),
    deserialize: RecordWordle.fromJson,
  );
}
