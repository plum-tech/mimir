import 'package:mimir/init.dart';
import 'package:mimir/lifecycle.dart';

import 'package:mimir/session/mimir.dart';

import '../entity/bulletin.dart';

class BulletinService {
  MimirSession get _session => Init.mimirSession;

  const BulletinService();

  Future<MimirBulletin?> getLatest() async {
    final res = await _session.request(
      "https://bulletin.api.mysit.life/v1/latest",
    );
    if (res.statusCode != 200) {
      return null;
    }
    return MimirBulletin.fromJson(res.data);
  }
}
