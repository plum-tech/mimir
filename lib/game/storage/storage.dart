import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:version/version.dart';

class GameStorageBox<TSave> {
  Box get _box => HiveInit.game;
  final String name;
  final Version version;
  final TSave Function(Map<String, dynamic> json) deserialize;
  final Map<String, dynamic> Function(TSave save) serialize;

  const GameStorageBox({
    required this.name,
    required this.version,
    required this.serialize,
    required this.deserialize,
  });

  Future<void> save(TSave save, {int slot = 0}) async {
    final json = serialize(save);
    final str = jsonEncode(json);
    await _box.put("/$name/$version/$slot", str);
  }

  Future<void> delete({int slot = 0}) async {
    await _box.delete("/$name/$version/$slot");
  }

  TSave? load({int slot = 0}) {
    final str = _box.get("/$name/$version/$slot");
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
    return _box.containsKey("/$name/$version/$slot");
  }

  Listenable listen({int slot = 0}) {
    return _box.listenable(keys: ["/$name/$version/$slot"]);
  }
}
