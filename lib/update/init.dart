import 'service/update.dart';

class UpdateInit {
  static late UpdateService service;

  static void init() {
    service = const UpdateService();
  }

  static void initStorage() {}
}
