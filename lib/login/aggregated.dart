import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/credentials/utils.dart';
import 'package:sit/init.dart';
import 'package:sit/settings/settings.dart';

import 'init.dart';

class LoginAggregated {
  static Future<void> login(Credentials credentials) async {
    final userType = guessOaUserType(credentials.account);
    await Init.ssoSession.loginLocked(credentials);
    // set user's real name to signature by default.
    final personName = await LoginInit.authServerService.getPersonName();
    Settings.lastSignature ??= personName;
    CredentialInit.storage.oaCredentials = credentials;
    CredentialInit.storage.oaLoginStatus = LoginStatus.validated;
    CredentialInit.storage.oaLastAuthTime = DateTime.now();
    CredentialInit.storage.oaUserType = userType;
  }
}
