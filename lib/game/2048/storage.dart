import 'package:sit/game/storage/record.dart';
import 'package:sit/game/storage/save.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/hive.dart';

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
  static final record = RecordStorage2048(
    () => HiveInit.game2048,
    prefix: _ns,
    serialize: (record) => record.toJson(),
    deserialize: Record2048.fromJson,
  );
}

class _K {
  static const bestScore = "bestScore";
}

class RecordStorage2048 extends GameRecordStorage<Record2048> {
  RecordStorage2048(
    super.box, {
    required super.prefix,
    required super.serialize,
    required super.deserialize,
  });

  String get _kBestScore => "$prefix/${_K.bestScore}";

  int get bestScore => box().safeGet<int>(_kBestScore) ?? 0;

  set bestScore(int newValue) => box().safePut<int>(_kBestScore, newValue);

  @override
  int add(Record2048 save) {
    final id = super.add(save);
    if (save.score > bestScore) {
      bestScore = save.score;
    }
    return id;
  }

  late final $bestScore = box().providerWithDefault<int>(
    _kBestScore,
    () => 0,
  );
}
