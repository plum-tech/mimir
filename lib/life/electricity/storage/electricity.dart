import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mimir/hive/using.dart';

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

  ValueListenable<Box<dynamic>> get $selectedRoom => box.listenable(keys:[_K.selectedRoom]);

  ElectricityBalance? get lastBalance => box.get(_K.lastBalance);

  set lastBalance(ElectricityBalance? newV) => box.put(_K.lastBalance, newV);

  List<String>? get searchHistory => box.get(_K.searchHistory);

  set searchHistory(List<String>? newV) => box.put(_K.searchHistory, newV);
}
