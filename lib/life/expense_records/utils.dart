import 'entity/local.dart';
import 'init.dart';

Future<void> fetchTransaction({
  required String studentId,
  required DateTime start,
  required DateTime end,
  void Function(List<Transaction>)? onLocalQuery,
}) async {
  for (int i = 0; i < 3; i++) {
    try {
      final records = await ExpenseRecordsInit.cache.fetch(
        studentID: studentId,
        from: start,
        to: end,
        onLocalQuery: onLocalQuery,
      );
      onLocalQuery?.call(records);
      return;
    } catch (_) {}
  }
}
