import 'service/freshman.dart';
import 'storage/freshman.dart';

class FreshmanInit {
  static late FreshmanService service;
  static late FreshmanStorage storage;

  static void init() {
    service = const FreshmanService();
    storage = FreshmanStorage();
  }
}
