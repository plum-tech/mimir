import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/balance.dart';

class _K {
  static const lastBalance = "/lastBalance";
  static const searchHistory = "/searchHistory";
  static const lastUpdateTime = "/lastUpdateTime";
}

class ElectricityStorage {
  Box get box => HiveInit.electricity;
  final int maxHistoryLength;

  const ElectricityStorage({
    this.maxHistoryLength = 20,
  });

  ValueListenable listenBalance() => box.listenable(keys: [_K.lastBalance]);

  ElectricityBalance? get lastBalance => box.safeGet(_K.lastBalance);

  set lastBalance(ElectricityBalance? newV) => box.safePut(_K.lastBalance, newV);

  List<String>? get searchHistory => box.safeGet(_K.searchHistory);

  set searchHistory(List<String>? newV) {
    if (newV != null) {
      newV = newV.sublist(0, min(newV.length, maxHistoryLength));
    }
    box.safePut(_K.searchHistory, newV);
  }

  DateTime? get lastUpdateTime => box.safeGet(_K.lastUpdateTime);

  set lastUpdateTime(DateTime? newV) => box.safePut(_K.lastUpdateTime, newV);

}

extension ElectricityStorageX on ElectricityStorage {
  void addSearchHistory(String room) {
    final searchHistory = this.searchHistory ?? <String>[];
    if (searchHistory.any((e) => e == room)) return;
    searchHistory.insert(0, room);
    this.searchHistory = searchHistory;
  }

  void selectNewRoom(String room) {
    Settings.life.electricity.selectedRoom = room;
    addSearchHistory(room);
  }
}
