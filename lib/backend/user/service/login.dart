import 'package:mimir/backend/user/entity/verify.dart';
import 'package:mimir/init.dart';
import 'package:mimir/session/mimir.dart';

import '../entity/user.dart';

// const _base = "https://api.mysit.life/v1";
const _base = "http://192.168.1.5:8000/v1";

class MimirLoginService {
  MimirSession get _session => Init.mimirSession;

  const MimirLoginService();

  Future<MimirAuthMethods> fetchAuthMethods({required SchoolCode school}) async {
    final res = await _session.request("$_base/auth/method", para: {
      "schoolCode": school.code,
    });
    return MimirAuthMethods.fromJson(res.data);
  }
}
