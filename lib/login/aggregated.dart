import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/credentials/utils.dart';
import 'package:sit/init.dart';
import 'package:sit/settings/meta.dart';
import 'package:sit/settings/settings.dart';

import 'init.dart';

class LoginAggregated {
  static Future<void> login(Credentials credentials) async {
    credentials = credentials.copyWith(
      account: credentials.account.toUpperCase(),
    );
    final userType = estimateOaUserType(credentials.account);
    await Init.ssoSession.deleteSitUriCookies();
    await Init.ssoSession.loginLocked(credentials);
    // set user's real name to signature by default.
    final personName = await LoginInit.authServerService.getPersonName();
    Meta.userRealName ??= personName;
    Settings.lastSignature ??= personName;
    CredentialsInit.storage.oaCredentials = credentials;
    CredentialsInit.storage.oaLoginStatus = LoginStatus.validated;
    CredentialsInit.storage.oaLastAuthTime = DateTime.now();
    CredentialsInit.storage.oaUserType = userType;
  }
}
