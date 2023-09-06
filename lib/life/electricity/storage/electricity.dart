import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  set selectedRoom(String? newV) {
    box.put(_K.selectedRoom, newV);
    if (newV == null) {
      box.put(_K.lastBalance, null);
    }
  }

  ValueListenable<Box<dynamic>> get onRoomBalanceChanged => box.listenable(keys: [_K.selectedRoom, _K.lastBalance]);

  ElectricityBalance? get lastBalance => box.get(_K.lastBalance);

  set lastBalance(ElectricityBalance? newV) => box.put(_K.lastBalance, newV);

  Set<String>? get searchHistory {
    final res = box.get(_K.searchHistory);
    if (res == null) return null;
    return Set.of(res);
  }

  set searchHistory(Set<String>? newV) => box.put(_K.searchHistory, newV);
}
