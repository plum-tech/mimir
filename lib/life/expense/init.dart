import 'package:hive/hive.dart';
import 'package:mimir/network/session.dart';

import 'cache/cache.dart';
import 'service/getter.dart';
import 'storage/local.dart';

class ExpenseTrackerInit {
  static late ExpenseGetService service;
  static late ExpenseStorage storage;
  static late CachedExpenseGetDao cache;

  static void init({
    required ISession session,
    required Box box,
  }) {
    service = ExpenseGetService(session);
    storage = ExpenseStorage(box);
    cache = CachedExpenseGetDao(service: service, storage: storage);
  }
}
