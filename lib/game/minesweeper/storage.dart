import 'package:mimir/game/storage/record.dart';
import 'package:mimir/game/storage/save.dart';
import 'package:mimir/storage/hive/init.dart';

import 'entity/save.dart';
import 'entity/record.dart';
import 'r.dart';

class StorageMinesweeper {
  static const _ns = "/${RMinesweeper.name}/${RMinesweeper.version}";
  static final save = GameSaveStorage<SaveMinesweeper>(
    () => HiveInit.gameMinesweeper,
    prefix: _ns,
    serialize: (save) => save.toJson(),
    deserialize: SaveMinesweeper.fromJson,
  );
  static final record = GameRecordStorage<RecordMinesweeper>(
    () => HiveInit.gameMinesweeper,
    prefix: _ns,
    serialize: (record) => record.toJson(),
    deserialize: RecordMinesweeper.fromJson,
  );
}
