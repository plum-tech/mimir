import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';

Map<String, dynamic> _defaultToJson(dynamic obj) {
  return obj.toJson();
}

class GameSaveStorage<TSave> {
  final Box Function() _box;
  final String prefix;
  final TSave Function(Map<String, dynamic> json) deserialize;
  final Map<String, dynamic> Function(TSave save) serialize;

  GameSaveStorage(
    this._box, {
    required this.prefix,
    this.serialize = _defaultToJson,
    required this.deserialize,
  });

  String get _prefix => "$prefix/save";

  Future<void> save(TSave save, {int slot = 0}) async {
    final json = serialize(save);
    final str = jsonEncode(json);
    await _box().safePut<String>("$_prefix/$slot", str);
  }

  Future<void> delete({int slot = 0}) async {
    await _box().delete("$_prefix/$slot");
  }

  TSave? load({int slot = 0}) {
    final str = _box().safeGet<String>("$_prefix/$slot");
    if (str == null) return null;
    try {
      final json = jsonDecode(str);
      final save = deserialize(json);
      return save;
    } catch (e) {
      return null;
    }
  }

  bool exists({int slot = 0}) {
    return _box().containsKey("$_prefix/$slot");
  }

  late final $saveOf = _box().providerFamily<TSave, int>(
    (slot) => "$_prefix/$slot",
    get: (slot) => load(slot: slot),
    set: (slot, v) async {
      if (v == null) {
        await delete(slot: slot);
      } else {
        await save(v, slot: slot);
      }
    },
  );

  late final $saveExistsOf = _box().existsChangeProviderFamily<int>(
    (slot) => "$_prefix/$slot",
  );

  Listenable listen({int slot = 0}) {
    return _box().listenable(keys: ["$_prefix/$slot"]);
  }
}
