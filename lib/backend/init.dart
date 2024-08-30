import 'bulletin/service/bulletin.dart';
import 'bulletin/storage/bulletin.dart';
import 'service/ocr.dart';
import 'update/service/update.dart';
import 'user/service/login.dart';

class BackendInit {
  static late MimirUpdateService update;
  static late MimirBulletinService bulletin;
  static late MimirBulletinStorage bulletinStorage;
  static late MimirLoginService login;
  static late MimirOcrService ocr;

  static void init() {
    update = const MimirUpdateService();
    bulletin = const MimirBulletinService();
    bulletinStorage = MimirBulletinStorage();
    login = const MimirLoginService();
    ocr = const MimirOcrService();
  }

  static void initStorage() {}
}
