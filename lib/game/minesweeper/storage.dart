import 'package:sit/game/storage/save.dart';
import 'package:sit/storage/hive/init.dart';

import 'entity/save.dart';

class StorageMinesweeper {
  static final save = GameSaveStorage<SaveMinesweeper>(
    () => HiveInit.gameMinesweeper,
    prefix: "/minesweeper/1",
    serialize: (save) => save.toJson(),
    deserialize: SaveMinesweeper.fromJson,
  );
}
