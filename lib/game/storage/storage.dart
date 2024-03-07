import 'package:hive/hive.dart';

abstract class GameStorageBox<TSave> {
  final String name;
  final GameStorageStore store;
  GameStorageBox(this.store, {required this.name});

  TSave getSave({int slot = 0});
  setSave(TSave save, {int slot = 0});
}

class GameStorageStore {
  final Box box;

  const GameStorageStore({required this.box});


}
