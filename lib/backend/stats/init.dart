import 'service/stats.dart';
import 'storage/stats.dart';

class StatsInit {
  static late final StatsStorage storage;
  static late final StatsService service;

  static void init() {
    service = StatsService();
  }

  static void initStorage() {
    storage = StatsStorage();
  }
}
