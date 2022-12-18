import 'package:hive/hive.dart';

import '../dao/local.dart';

class ElectricityStorage implements ElectricityStorageDao {
  final Box<dynamic> box;

  ElectricityStorage(this.box);

  @override
  List<String>? get searchHistory => box.get('/lastRoomList');

  @override
  set searchHistory(List<String>? roomList) => box.put('/lastRoomList', roomList);
}
