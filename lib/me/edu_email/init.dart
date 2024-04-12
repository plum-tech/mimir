import 'service/email.dart';
import 'storage/email.dart';

class EduEmailInit {
  static late EduEmailStorage storage;
  static late MailService service;

  static void init() {
    service = MailService();
  }
  static void initStorage() {
    storage = const EduEmailStorage();
  }
}
