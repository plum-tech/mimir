import 'package:mimir/init.dart';
import 'package:mimir/lifecycle.dart';

import 'package:mimir/session/mimir.dart';

import '../entity/bulletin.dart';

class BulletinService {
  MimirSession get _session => Init.mimirSession;

  const BulletinService();

  Future<MimirBulletin?> getLatest() async {
    final res = await _session.request(
      "https://bulletin.mysit.life/v1/latest?lang=${$locale}",
    );
    if (res.statusCode != 200) {
      return null;
    }
    return MimirBulletin.fromJson(res.data);
  }

  Future<List<MimirBulletin>> getList() async {
    final res = await _session.request(
      "https://bulletin.mysit.life/v1/list?lang=${$locale}",
    );
    if (res.statusCode != 200) {
      return const [];
    }
    final list = res.data as List;
    return list.map((b) => MimirBulletin.fromJson(b)).toList(growable: false);
  }
}
