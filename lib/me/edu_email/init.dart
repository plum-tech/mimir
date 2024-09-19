import 'package:mimir/me/edu_email/service/email.demo.dart';
import 'package:mimir/settings/dev.dart';

import 'service/email.dart';
import 'storage/email.dart';

class EduEmailInit {
  static late EduEmailStorage storage;
  static late MailService service;

  static void init() {
    service = Dev.demoMode ? DemoMailService() : MailService();
  }

  static void initStorage() {
    storage = const EduEmailStorage();
  }
}
