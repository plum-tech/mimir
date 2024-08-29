import 'package:mimir/backend/bulletin/storage/bulletin.dart';

import 'bulletin/service/bulletin.dart';
import 'update/service/update.dart';
import 'user/service/login.dart';

class BackendInit {
  static late MimirUpdateService update;
  static late MimirBulletinService bulletin;
  static late MimirBulletinStorage bulletinStorage;
  static late MimirLoginService login;

  static void init() {
    update = const MimirUpdateService();
    bulletin = const MimirBulletinService();
    bulletinStorage = MimirBulletinStorage();
    login = const MimirLoginService();
  }

  static void initStorage() {}
}
