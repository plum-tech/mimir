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
  // future goes first.
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
