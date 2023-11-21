import 'service/fetch.dart';
import 'storage/local.dart';

class ExpenseRecordsInit {
  static late ExpenseFetchService service;
  static late ExpenseStorage storage;

  static void init() {
    service = const ExpenseFetchService();
    storage = const ExpenseStorage();
  }
}
