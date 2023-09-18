import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/balance.dart';

class _K {
  static const selectedRoom = "/selectedRoom";
  static const lastBalance = "/lastBalance";
  static const searchHistory = "/searchHistory";
}

class ElectricityStorage {
  final Box<dynamic> box;
  final int maxHistoryLength;

  ElectricityStorage(
    this.box, {
    this.maxHistoryLength = 20,
  });

  String? get selectedRoom => box.get(_K.selectedRoom);

  set selectedRoom(String? newV) {
    box.put(_K.selectedRoom, newV);
    if (newV == null) {
      box.put(_K.lastBalance, null);
    }
  }

  ValueListenable<Box> listenRoomBalanceChange() => box.listenable(keys: [_K.selectedRoom, _K.lastBalance]);

  ElectricityBalance? get lastBalance => box.get(_K.lastBalance);

  set lastBalance(ElectricityBalance? newV) => box.put(_K.lastBalance, newV);

  List<String>? get searchHistory => box.get(_K.searchHistory);

  set searchHistory(List<String>? newV) {
    if (newV != null) {
      newV = newV.sublist(0, min(newV.length, maxHistoryLength));
    }
    box.put(_K.searchHistory, newV);
  }
}

extension ElectricityStorageX on ElectricityStorage {
  void addSearchHistory(String room) {
    final searchHistory = this.searchHistory ?? <String>[];
    if (searchHistory.any((e) => e == room)) return;
    searchHistory.insert(0, room);
    this.searchHistory = searchHistory;
  }

  void selectNewRoom(String room) {
    selectedRoom = room;
    addSearchHistory(room);
  }
}
