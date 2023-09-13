import 'package:hive/hive.dart';

const _kElectricityAutoRefresh = true;
const _kExpenseRecordsAutoRefresh = true;

class LifeSettings {
  final Box<dynamic> box;

  LifeSettings(this.box);

  late final electricity = _Electricity(box);
  late final expense = _ExpenseRecords(box);

  static const ns = "/life";
}

class _Electricity {
  final Box<dynamic> box;

  const _Electricity(this.box);

  static const _ns = "${LifeSettings.ns}/electricity";
  static const _autoRefresh = "$_ns/autoRefresh";

  /// enable by default
  bool get autoRefresh => box.get(_autoRefresh) ?? _kElectricityAutoRefresh;

  set autoRefresh(bool foo) => box.put(_autoRefresh, foo);
}

class _ExpenseRecords {
  final Box<dynamic> box;

  const _ExpenseRecords(this.box);

  static const _ns = "${LifeSettings.ns}/expenseRecords";
  static const _autoRefresh = "$_ns/autoRefresh";

  bool get autoRefresh => box.get(_autoRefresh) ?? _kExpenseRecordsAutoRefresh;

  set autoRefresh(bool foo) => box.put(_autoRefresh, foo);
}
