import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/hive/type_id.dart';

import '../entity/local.dart';

class _K {
  static const _namespace = '/expense';
  static const transactionTsList = '$_namespace/transactionIdList';

  static String buildTransactionsKeyByTs(DateTime ts) {
    final id = (ts.millisecondsSinceEpoch ~/ 1000).toRadixString(16);
    return '/expense/transactions/$id';
  }

  static const cachedTsStart = '/expense/cachedTsRange/start';
  static const cachedTsEnd = '/expense/cachedTsRange/end';
}

class ExpenseStorage {
  final Box box;

  const ExpenseStorage(this.box);

  /// 清空所有交易记录
  void clear() => box.clear();

  /// 合并若干交易记录
  void merge({
    required Iterable<Transaction> records,
    required DateTime start,
    required DateTime end,
  }) {
    // 需要实现records中的时间与transactionTsList中的时间的合并并保证合并后有序
    final result = {...records.map((e) => e.datetime), ...transactionTsList}.toList();
    result.sort((a, b) => a.compareTo(b));
    box.put(_K.transactionTsList, result);
    // 空集赋值
    cachedTsStart ??= start;
    cachedTsEnd ??= end;
    // start 比 cachedTsStart 还靠前
    if (start.isBefore(cachedTsStart!)) cachedTsStart = start;
    // end 比 cachedTsEnd 还靠后
    if (end.isAfter(cachedTsEnd!)) cachedTsEnd = end;

    for (final record in records) {
      box.put(_K.buildTransactionsKeyByTs(record.datetime), record);
    }
  }

  /// 所有交易记录的索引，记录所有的交易时间，需要保证有序，以实现二分查找
  List<DateTime> get transactionTsList {
    final v = box.get(_K.transactionTsList);
    if (v == null) return [];
    return List.unmodifiable(v);
  }

  ValueListenable<Box> get $transactionTsList => box.listenable(keys: [_K.transactionTsList]);

  /// 通过一个时间范围[start, end]来获得交易记录
  List<DateTime> getTransactionTsByRange({
    DateTime? start,
    DateTime? end,
  }) {
    return transactionTsList
        .where((e) => start == null || e == start || e.isAfter(start))
        .where((e) => end == null || e == end || e.isBefore(end))
        .toList();
  }

  /// 通过某个时刻来获得交易记录
  Transaction? getTransactionByTs(DateTime ts) => box.get(_K.buildTransactionsKeyByTs(ts));

  /// 获取已缓存的交易起始时间
  DateTime? get cachedTsStart => box.get(_K.cachedTsStart);

  set cachedTsStart(DateTime? v) => box.put(_K.cachedTsStart, v);

  /// 获取已缓存的交易结束时间
  DateTime? get cachedTsEnd => box.get(_K.cachedTsEnd);

  set cachedTsEnd(DateTime? v) => box.put(_K.cachedTsEnd, v);
}
