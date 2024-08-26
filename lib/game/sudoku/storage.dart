import 'package:mimir/game/storage/record.dart';
import 'package:mimir/game/storage/save.dart';
import 'package:mimir/storage/hive/init.dart';

import 'entity/record.dart';
import 'entity/save.dart';
import 'r.dart';

class StorageSudoku {
  static const _ns = "/${RSudoku.name}/${RSudoku.version}";
  static final save = GameSaveStorage<SaveSudoku>(
    () => HiveInit.gameSudoku,
    prefix: _ns,
    serialize: (save) => save.toJson(),
    deserialize: SaveSudoku.fromJson,
  );
  static final record = GameRecordStorage<RecordSudoku>(
    () => HiveInit.gameSudoku,
    prefix: _ns,
    serialize: (record) => record.toJson(),
    deserialize: RecordSudoku.fromJson,
  );
}
