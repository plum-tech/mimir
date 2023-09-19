import 'package:collection/collection.dart';
import 'package:mimir/life/expense_records/entity/local.dart';

import 'init.dart';

Future<void> fetchAndSaveTransactionUntilNow({
  required String studentId,
}) async {
  final storage = ExpenseRecordsInit.storage;
  final end = DateTime.now();
  final start = storage.lastFetchedTs ?? end.copyWith(year: end.year - 4);
  final transactions = await ExpenseRecordsInit.service.fetch(
    studentID: studentId,
    from: start,
    to: end,
  );
  ExpenseRecordsInit.storage.lastFetchedTs = end;
  final newTsList = {...transactions.map((e) => e.timestamp), ...storage.transactionTsList ?? const []}.toList();
  // the latest goes first
  newTsList.sort((a, b) => a.compareTo(b));
  storage.transactionTsList = newTsList;
  for (final transaction in transactions) {
    storage.setTransactionByTs(transaction.timestamp, transaction);
  }
  final latest = transactions.firstOrNull;
  if (latest != null) {
    ExpenseRecordsInit.storage.latestTransaction = latest;
  }
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


({double income, double outcome}) accumulateTransactions(List<Transaction> transactions) {
  double income = 0;
  double outcome = 0;
  for (final t in transactions) {
    if (t.isConsume) {
      outcome += t.deltaAmount;
    } else {
      if (t.type == TransactionType.subsidy && t.deviceName.contains("支付宝领取终端")) {
        income += t.deltaAmount;
      }
    }
  }
  return (income: income, outcome: outcome);
}
