import 'bulletin/service/bulletin.dart';
import 'update/service/update.dart';

class BackendInit {
  static late UpdateService update;
  static late BulletinService bulletin;

  static void init() {
    update = const UpdateService();
    bulletin = const BulletinService();
  }

  static void initStorage() {}
}
