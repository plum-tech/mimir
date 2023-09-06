import 'package:hive/hive.dart';

class ElectricityStorage {
  final Box<dynamic> box;

  ElectricityStorage(this.box);

  List<String>? get searchHistory => box.get('/lastRoomList');

  set searchHistory(List<String>? roomList) => box.put('/lastRoomList', roomList);
}
