import 'service/update.dart';

class TimetableInit {
  static late UpdateService service;

  static void init() {
    service = const UpdateService();
  }
}
