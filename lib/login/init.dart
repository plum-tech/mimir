import 'package:mimir/session/sso.dart';

import 'service/authserver.dart';

class LoginInit {
  static late AuthServerService authServerService;
  static late SsoSession ssoSession;

  static void init({
    required SsoSession ssoSession,
  }) {
    LoginInit.ssoSession = ssoSession;
    authServerService = AuthServerService(ssoSession);
  }
}
