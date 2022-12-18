import 'package:hive/hive.dart';

import 'dao/email.dart';
import 'storage/mail.dart';

class EduEmailInit {
  static late EmailStorageDao mail;

  static Future<void> init() async {
    final mailStorage = await Hive.openBox<dynamic>('mail');
    mail = MailStorage(mailStorage);
  }
}
