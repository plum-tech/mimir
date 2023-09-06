import '../entity/local.dart';

abstract class ExpenseGetDao {
  Future<List<Transaction>> fetch({
    required String studentID,
    required DateTime from,
    required DateTime to,
  });
}
