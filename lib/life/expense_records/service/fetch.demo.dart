import '../entity/local.dart';
import 'fetch.dart';

class DemoExpenseService implements ExpenseService {
  const DemoExpenseService();

  @override
  Future<List<Transaction>> fetch({
    required String studentID,
    required DateTime from,
    required DateTime to,
  }) async {
    return [
      Transaction(
        timestamp: DateTime.now(),
        consumerId: 99999,
        type: TransactionType.food,
        balanceBefore: 99.99,
        balanceAfter: 69.99,
        deltaAmount: 30.00,
        // TODO: l10n
        deviceName: "SIT Life canteen",
        note: "Tasty",
      ),
    ];
  }
}
