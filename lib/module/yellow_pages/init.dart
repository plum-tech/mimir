import 'dao/contact.dart';
import 'entity/contact.dart';
import 'service/contact.dart';
import 'storage/contact.dart';
import 'using.dart';

class YellowPagesInit {
  static late ContactStorageDao contactStorageDao;
  static late ContactRemoteDao contactRemoteDao;

  static Future<void> init({
    required ISession kiteSession,
    required Box<ContactData> contactDataBox,
  }) async {
    contactStorageDao = ContactDataStorage(contactDataBox);
    contactRemoteDao = ContactRemoteService(kiteSession);
  }
}
