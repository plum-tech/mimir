import 'package:hive/hive.dart';
import 'package:mimir/network/session.dart';

import 'cache/cache.dart';
import 'dao/getter.dart';
import 'service/getter.dart';
import 'storage/local.dart';

class ExpenseTrackerInit {
  static late ExpenseGetDao remote;
  static late ExpenseStorage storage;
  static late CachedExpenseGetDao cache;

  static void init({
    required ISession session,
    required Box expenseBox,
  }) {
    remote = ExpenseGetService(session);
    storage = ExpenseStorage(expenseBox);
    cache = CachedExpenseGetDao(remoteDao: remote, storage: storage);
  }
}
