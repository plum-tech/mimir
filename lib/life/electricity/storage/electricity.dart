import 'package:hive/hive.dart';

import '../entity/balance.dart';

class _K {
  static const selectedRoom = "/selectedRoom";
  static const lastBalance = "/lastBalance";
  static const searchHistory = "/searchHistory";
}

class ElectricityStorage {
  final Box<dynamic> box;

  ElectricityStorage(this.box);

  String? get selectedRoom => box.get(_K.selectedRoom);

  set selectedRoom(String? newV) => box.put(_K.selectedRoom, newV);

  ElectricityBalance? get lastBalance => box.get(_K.lastBalance);

  set lastBalance(ElectricityBalance? newV) => box.put(_K.lastBalance, newV);

  List<String>? get searchHistory => box.get(_K.searchHistory);

  set searchHistory(List<String>? newV) => box.put(_K.searchHistory, newV);
}
