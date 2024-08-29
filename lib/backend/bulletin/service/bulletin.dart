import 'package:mimir/init.dart';

import 'package:mimir/session/mimir.dart';

import '../entity/bulletin.dart';

const _base = "https://bulletin.mysit.life/v1";

class MimirBulletinService {
  MimirSession get _session => Init.mimirSession;

  const MimirBulletinService();

  Future<MimirBulletin?> getLatest() async {
    final res = await _session.request("$_base/latest");
    if (res.statusCode != 200) {
      return null;
    }
    return MimirBulletin.fromJson(res.data);
  }

  Future<List<MimirBulletin>> getList() async {
    final res = await _session.request("$_base/list");
    if (res.statusCode != 200) {
      return const [];
    }
    final list = res.data as List;
    return list.map((b) => MimirBulletin.fromJson(b)).toList(growable: false);
  }
}
