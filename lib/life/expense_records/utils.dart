import 'package:collection/collection.dart';
import 'package:sit/life/expense_records/entity/local.dart';

import 'package:sit/school/utils.dart';

import 'entity/remote.dart';

const deviceName2Type = {
  '开水': TransactionType.water,
  '浴室': TransactionType.shower,
  '咖啡吧': TransactionType.coffee,
  '食堂': TransactionType.food,
  '超市': TransactionType.store,
  '图书馆': TransactionType.library,
};

TransactionType parseType(Transaction trans) {
  if (trans.note.contains("补助")) {
    return TransactionType.subsidy;
  } else if (trans.note.contains("充值") || trans.note.contains("余额转移") || !trans.isConsume) {
    return TransactionType.topUp;
  } else if (trans.note.contains("消费") || trans.isConsume) {
    for (MapEntry<String, TransactionType> entry in deviceName2Type.entries) {
      String name = entry.key;
      TransactionType type = entry.value;
      if (trans.deviceName.contains(name)) {
        return type;
      }
    }
  }
  return TransactionType.other;
}

Transaction parseFull(TransactionRaw raw) {
  final transaction = Transaction(
    timestamp: parseDatetime(raw),
    balanceBefore: raw.balanceBeforeTransaction,
    balanceAfter: raw.balanceAfterTransaction,
    deltaAmount: raw.amount.abs(),
    deviceName: mapChinesePunctuations(raw.deviceName ?? ""),
    note: raw.name,
    consumerId: raw.customerId,
    type: TransactionType.other,
  );
  return transaction.copyWith(
    type: parseType(transaction),
  );
}

DateTime parseDatetime(TransactionRaw raw) {
  final date = raw.date;
  final year = int.parse(date.substring(0, 4));
  final month = int.parse(date.substring(4, 6));
  final day = int.parse(date.substring(6, 8));

  final time = raw.time;
  final hour = int.parse(time.substring(0, 2));
  final min = int.parse(time.substring(2, 4));
  final sec = int.parse(time.substring(4, 6));
  return DateTime(year, month, day, hour, min, sec);
}

typedef YearMonth = ({int year, int month});

extension YearMonthX on YearMonth {
  int compareTo(YearMonth other, {bool ascending = true}) {
    final sign = ascending ? 1 : -1;
    return switch (this.year - other.year) {
      > 0 => 1 * sign,
      < 0 => -1 * sign,
      _ => switch (this.month - other.month) {
          > 0 => 1 * sign,
          < 0 => -1 * sign,
          _ => 0,
        }
    };
  }

  DateTime toDateTime() => DateTime(year, month);
}

List<({YearMonth time, List<Transaction> records})> groupTransactionsByMonthYear(
  List<Transaction> records,
) {
  final groupByYearMonth = records
      .groupListsBy((r) => (year: r.timestamp.year, month: r.timestamp.month))
      .entries
      // the latest goes first
      .map((e) => (time: e.key, records: e.value.sorted((a, b) => -a.timestamp.compareTo(b.timestamp))))
      .toList();
  groupByYearMonth.sort((a, b) => a.time.compareTo(b.time, ascending: false));
  return groupByYearMonth;
}

bool validateTransaction(Transaction t) {
  if (t.type == TransactionType.topUp) {
    return false;
  }
  return true;
}

/// Accumulates the income and outcome.
/// Ignores invalid transactions by [validateTransaction].
({double income, double outcome}) accumulateTransactionIncomeOutcome(List<Transaction> transactions) {
  double income = 0;
  double outcome = 0;
  for (final t in transactions) {
    if (!validateTransaction(t)) continue;
    if (t.isConsume) {
      outcome += t.deltaAmount;
    } else {
      income += t.deltaAmount;
    }
  }
  return (income: income, outcome: outcome);
}

/// Accumulates the [Transaction.deltaAmount].
double accumulateTransactionAmount(List<Transaction> transactions) {
  var total = 0.0;
  for (final t in transactions) {
    total += t.deltaAmount;
  }
  return total;
}
