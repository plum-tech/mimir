import 'package:hive/hive.dart';
import 'package:version/version.dart';

abstract class GameSaveSerializer<TSave> {
  TSave deserialize(Map<String, dynamic> json);

  Map<String, dynamic> serialize(TSave save);
}

abstract class GameStorageBox<TSave> {
  final String name;
  final Version version;
  final GameStorageStore store;
  final GameSaveSerializer<TSave> serializer;

  const GameStorageBox({
    required this.name,
    required this.store,
    required this.version,
    required this.serializer,
  });
}

class GameStorageStore {
  final Box box;

  const GameStorageStore({required this.box});

  Future<void> save(String key, String value) async {
    await box.put(key, value);
  }

  String? load(String key) {
    return box.get(key);
  }

  bool existing(String key) {
    return box.containsKey(key);
  }
}
