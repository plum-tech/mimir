import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/local.dart';

class _K {
  static const transactionTsList = '/transactionTsList';

  static String buildTransactionsKey(DateTime timestamp) {
    final id = (timestamp.millisecondsSinceEpoch ~/ 1000).toRadixString(16);
    return '/transactions/$id';
  }

  static const lastFetchedTs = "/lastFetchedTs";
  static const latestTransaction = "/latestTransaction";
}

class ExpenseStorage {
  final Box box;

  const ExpenseStorage(this.box);

  /// 所有交易记录的索引，记录所有的交易时间，需要保证有序，以实现二分查找
  List<DateTime>? get transactionTsList => (box.get(_K.transactionTsList) as List?)?.cast<DateTime>();

  set transactionTsList(List<DateTime>? newV) => box.put(_K.transactionTsList, newV);

  ValueListenable<Box<dynamic>> get $transactionTsList => box.listenable(keys: [_K.transactionTsList]);

  /// 通过某个时刻来获得交易记录
  Transaction? getTransactionByTs(DateTime ts) => box.get(_K.buildTransactionsKey(ts));

  setTransactionByTs(DateTime ts, Transaction? transaction) => box.put(_K.buildTransactionsKey(ts), transaction);

  DateTime? get lastFetchedTs => box.get(_K.lastFetchedTs);

  set lastFetchedTs(DateTime? v) => box.put(_K.lastFetchedTs, v);

  Transaction? get latestTransaction => box.get(_K.latestTransaction);

  set latestTransaction(Transaction? v) => box.put(_K.latestTransaction, v);

  ValueListenable<Box> get $lastTransaction => box.listenable(keys: [_K.latestTransaction]);
}

extension ExpenseStorageX on ExpenseStorage {
  /// 通过一个时间范围[start, end]来获得交易记录
  List<DateTime> getTransactionTsByRange({
    DateTime? start,
    DateTime? end,
  }) {
    final list = transactionTsList;
    if (list == null) return [];
    return list
        .where((e) => start == null || e == start || e.isAfter(start))
        .where((e) => end == null || e == end || e.isBefore(end))
        .toList();
  }

  List<Transaction> getTransactionsByRange({
    DateTime? start,
    DateTime? end,
  }) {
    final timestamps = getTransactionTsByRange(start: start,end: end);
    final transactions = <Transaction>[];
    for(final ts in timestamps){
      final transaction = getTransactionByTs(ts);
      if(transaction != null) transactions.add(transaction);
    }
    return transactions;
  }
}
