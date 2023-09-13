import 'entity/local.dart';
import 'init.dart';

Future<void> fetchTransaction({
  required String studentId,
  void Function(List<Transaction>)? onLocalQuery,
}) async {
  final end = DateTime.now();
  final start = DateTime(2010);
  // final start = ExpenseRecordsInit.storage.lastFetchedTs ?? DateTime(2010);
  final records = await ExpenseRecordsInit.cache.fetch(
    studentID: studentId,
    from: start,
    to: end,
    onLocalQuery: onLocalQuery,
  );
  onLocalQuery?.call(records);
  // ExpenseRecordsInit.storage.lastFetchedTs = end;
}
