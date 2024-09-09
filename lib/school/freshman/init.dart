import 'service/school.dart';

class FreshmanInit {
  static late FreshmanService service;

  static void init() {
    service = const FreshmanService();
  }
}
