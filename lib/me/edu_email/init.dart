import 'package:hive/hive.dart';

import 'service/email.dart';
import 'storage/email.dart';

class EduEmailInit {
  static late EduEmailStorage storage;
  static late MailService service;

  static void init({
    required Box box,
  }) {
    storage = EduEmailStorage(box);
    service = MailService();
  }
}
