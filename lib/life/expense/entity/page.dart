import 'local.dart';
import 'shared.dart';

class Page {
  DateTime month = defaultDateTime;
  List<Transaction> descending = [];

  bool get isEmpty => descending.isEmpty;

  double get lastBalance => descending.isEmpty ? 0 : descending.last.balanceAfter;
}

class CardBalance {
  double get lastBalance => descending.isEmpty ? 0 : descending.last.lastBalance;

  List<Page> descending = [];

  bool get isEmpty => descending.isEmpty;
}
