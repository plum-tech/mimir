import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:version/version.dart';

class GameStorageBox<TSave> {
  Box Function() _box;
  final String name;
  final Version version;
  final TSave Function(Map<String, dynamic> json) deserialize;
  final Map<String, dynamic> Function(TSave save) serialize;

  GameStorageBox(
    this._box, {
    required this.name,
    required this.version,
    required this.serialize,
    required this.deserialize,
  });

  Future<void> save(TSave save, {int slot = 0}) async {
    final json = serialize(save);
    final str = jsonEncode(json);
    await _box().safePut<String>("/$name/$version/$slot", str);
  }

  Future<void> delete({int slot = 0}) async {
    await _box().delete("/$name/$version/$slot");
  }

  TSave? load({int slot = 0}) {
    final str = _box().safeGet<String>("/$name/$version/$slot");
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
    return _box().containsKey("/$name/$version/$slot");
  }

  late final $saveOf = _box().providerFamily<TSave, int>(
    (slot) => "/$name/$version/$slot",
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
    (slot) => "/$name/$version/$slot",
  );

  Listenable listen({int slot = 0}) {
    return _box().listenable(keys: ["/$name/$version/$slot"]);
  }
}
