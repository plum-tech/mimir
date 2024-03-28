import 'package:flutter/foundation.dart';
import 'package:sit/utils/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _kElectricityAutoRefresh = true;
const _kExpenseRecordsAutoRefresh = true;

class LifeSettings {
  final Box box;

  LifeSettings(this.box);

  late final electricity = _Electricity(box);
  late final expense = _ExpenseRecords(box);

  static const ns = "/life";
}

class _ElectricityK {
  static const ns = "${LifeSettings.ns}/electricity";
  static const autoRefresh = "$ns/autoRefresh";
  static const selectedRoom = "$ns/selectedRoom";
}

class _Electricity {
  final Box box;

  _Electricity(this.box);

  bool get autoRefresh => box.safeGet(_ElectricityK.autoRefresh) ?? _kElectricityAutoRefresh;

  set autoRefresh(bool foo) => box.safePut(_ElectricityK.autoRefresh, foo);

  String? get selectedRoom => box.safeGet(_ElectricityK.selectedRoom);

  late final $selectedRoom = box.provider<String>(_ElectricityK.selectedRoom);

  set selectedRoom(String? newV) => box.safePut(_ElectricityK.selectedRoom, newV);

  ValueListenable listenSelectedRoom() => box.listenable(keys: [_ElectricityK.selectedRoom]);
}

class _ExpenseK {
  static const ns = "${LifeSettings.ns}/expenseRecords";
  static const autoRefresh = "$ns/autoRefresh";
}

class _ExpenseRecords {
  final Box box;

  const _ExpenseRecords(this.box);

  bool get autoRefresh => box.safeGet(_ExpenseK.autoRefresh) ?? _kExpenseRecordsAutoRefresh;

  set autoRefresh(bool foo) => box.safePut(_ExpenseK.autoRefresh, foo);
}
