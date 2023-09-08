import 'local.dart';

final _kMonth = DateTime.utc(0);

class Page {
  DateTime month = _kMonth;
  List<Transaction> descending = [];

  bool get isEmpty => descending.isEmpty;

  double get lastBalance => descending.isEmpty ? 0 : descending.last.balanceAfter;
}

class CardBalance {
  double get lastBalance => descending.isEmpty ? 0 : descending.last.lastBalance;

  List<Page> descending = [];

  bool get isEmpty => descending.isEmpty;
}
