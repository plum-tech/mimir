import 'package:sit/settings/settings.dart';

import 'service/fetch.dart';
import 'service/fetch.demo.dart';
import 'storage/local.dart';

class ExpenseRecordsInit {
  static late ExpenseService service;
  static late ExpenseStorage storage;

  static void init() {
    service = Settings.demoMode ? const DemoExpenseService() : const ExpenseService();
    storage = const ExpenseStorage();
  }
}
