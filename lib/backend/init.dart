import 'package:mimir/backend/bulletin/storage/bulletin.dart';

import 'bulletin/service/bulletin.dart';
import 'update/service/update.dart';

class BackendInit {
  static late UpdateService update;
  static late BulletinService bulletin;
  static late BulletinStorage bulletinStorage;

  static void init() {
    update = const UpdateService();
    bulletin = const BulletinService();
    bulletinStorage = BulletinStorage();
  }

  static void initStorage() {}
}
