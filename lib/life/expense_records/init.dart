import 'package:hive/hive.dart';

import 'service/fetch.dart';
import 'storage/local.dart';

class ExpenseRecordsInit {
  static late ExpenseFetchService service;
  static late ExpenseStorage storage;

  static void init({
    required Box box,
  }) {
    service = const ExpenseFetchService();
    storage = ExpenseStorage(box);
  }
}
