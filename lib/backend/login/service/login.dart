import 'package:mimir/backend/login/entity/verify.dart';
import 'package:mimir/init.dart';
import 'package:mimir/session/mimir.dart';

const _base = "https://api.mysit.life/v1";

class LoginService {
  MimirSession get _session => Init.mimirSession;

  const LoginService();

  Future<MimirVerifyMethods> fetchAuthMethods() async {
    final res = await _session.request("$_base/auth/method");
    return MimirVerifyMethods.fromJson(res.data);
  }
}
