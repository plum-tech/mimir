import 'package:mimir/session/sso/index.dart';

class HomeInit {
  static late SsoSession ssoSession;

  static init({
    required SsoSession ssoSession,
  }) {
    HomeInit.ssoSession = ssoSession;
  }
}
