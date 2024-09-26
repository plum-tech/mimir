import 'package:mimir/backend/bulletin/entity/bulletin.dart';
import 'package:mimir/backend/init.dart';
import 'package:mimir/backend/stats/utils/stats.dart';
import 'package:mimir/feature/feature.dart';

class XBulletin {
  static Future<MimirBulletin?> getLatest() async {
    var bulletin = await BackendInit.bulletin.getLatest();
    if (bulletin != null && bulletin.isEmpty) {
      bulletin = null;
    }
    BackendInit.bulletinStorage.latest = bulletin;
    return bulletin;
  }

  static Future<List<MimirBulletin>> getList() async {
    final list = await BackendInit.bulletin.getList();
    Stats.feature(AppFeature.mimirBulletin, "/list");
    BackendInit.bulletinStorage.list = list;
    return list;
  }
}
