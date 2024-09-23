import 'bulletin/service/bulletin.dart';
import 'bulletin/storage/bulletin.dart';
import 'service/ocr.dart';
import 'update/service/update.dart';
import 'user/service/auth.dart';

class BackendInit {
  static late MimirUpdateService update;
  static late MimirBulletinService bulletin;
  static late MimirBulletinStorage bulletinStorage;
  static late MimirAuthService auth;
  static late MimirOcrService ocr;

  static void init() {
    // update =  MimirUpdateServiceMock();
    update = const MimirUpdateService();
    bulletin = const MimirBulletinService();
    auth = const MimirAuthService();
    ocr = const MimirOcrService();
  }

  static void initStorage() {
    bulletinStorage = MimirBulletinStorage();
  }
}
