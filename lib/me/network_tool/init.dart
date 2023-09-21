import 'package:mimir/session/sso.dart';

class ConnectivityInit {
  static late SsoSession ssoSession;

  static void init({required SsoSession ssoSession}) {
    ConnectivityInit.ssoSession = ssoSession;
  }
}
