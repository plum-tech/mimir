import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/game/entity/record.dart';
import 'package:sit/storage/hive/table.dart';
import 'package:sit/utils/hive.dart';

class GameRecordStorage<TRecord extends GameRecord> {
  final Box Function() box;
  final String prefix;
  final TRecord Function(Map<String, dynamic> json) deserialize;
  final Map<String, dynamic> Function(TRecord save) serialize;

  GameRecordStorage(
    this.box, {
    required String prefix,
    required this.serialize,
    required this.deserialize,
  }) : prefix = "$prefix/record";

  late final table = HiveTable<TRecord>(
    base: prefix,
    box: box(),
    useJson: (fromJson: deserialize, toJson: serialize),
  );

  int add(TRecord save) {
    final id = table.add(save);
    return id;
  }

  void delete({required int id}) {
    table.delete(id);
  }

  void clear() {
    table.drop();
  }

  late final $recordOf = box().providerFamily<TRecord, int>(
    (id) => "$prefix/$id",
    get: (id) => table[id],
    set: (id, v) async {
      if (v == null) {
        delete(id: id);
      } else {
        table[id] = v;
      }
    },
  );
}
