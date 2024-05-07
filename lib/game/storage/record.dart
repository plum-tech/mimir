import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/game/entity/record.dart';
import 'package:sit/storage/hive/table.dart';
import 'package:sit/utils/hive.dart';

class GameRecordStorage<TRecord extends GameRecord> {
  final Box Function() _box;
  final String prefix;
  final TRecord Function(Map<String, dynamic> json) deserialize;
  final Map<String, dynamic> Function(TRecord save) serialize;

  final String _prefix;

  GameRecordStorage(
    this._box, {
    required this.prefix,
    required this.serialize,
    required this.deserialize,
  }) : _prefix = "$prefix/record";

  late final table = HiveTable<TRecord>(
    base: _prefix,
    box: _box(),
    useJson: (fromJson: deserialize, toJson: serialize),
  );

  int add(TRecord save) {
    final id = table.add(save);
    return id;
  }

  void delete({required int id}) {
    table.delete(id);
  }

  late final $recordOf = _box().providerFamily<TRecord, int>(
    (id) => "$_prefix/$id",
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
