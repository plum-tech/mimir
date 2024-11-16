import 'bulletin/service/bulletin.dart';
import 'bulletin/storage/bulletin.dart';
import 'update/service/update.dart';

class BackendInit {
  static late MimirUpdateService update;
  static late MimirBulletinService bulletin;
  static late MimirBulletinStorage bulletinStorage;

  static void init() {
    // update =  MimirUpdateServiceMock();
    update = const MimirUpdateService();
    bulletin = const MimirBulletinService();
  }

  static void initStorage() {
    bulletinStorage = MimirBulletinStorage();
  }
}
