import 'package:sit/game/minesweeper/entity/record.dart';
import 'package:sit/game/storage/record.dart';
import 'package:sit/game/storage/save.dart';
import 'package:sit/storage/hive/init.dart';

import 'entity/save.dart';
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
