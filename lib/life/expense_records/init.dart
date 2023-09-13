import 'package:hive/hive.dart';
import 'package:mimir/network/session.dart';

import 'service/fetch.dart';
import 'storage/local.dart';

class ExpenseRecordsInit {
  static late ExpenseFetchService service;
  static late ExpenseStorage storage;

  static void init({
    required ISession session,
    required Box box,
  }) {
    service = ExpenseFetchService(session);
    storage = ExpenseStorage(box);
  }
}
