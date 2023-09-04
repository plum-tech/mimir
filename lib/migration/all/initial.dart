import 'package:mimir/credential/symbol.dart';
import 'package:mimir/credential/using.dart';

import '../foundation.dart';

// ignore: non_constant_identifier_names
final NoVersionSpecifiedMigration = _NoVersionSpecifiedMigrationImpl();

class _NoVersionSpecifiedMigrationImpl extends Migration {
  @override
  Future<void> perform() async {
    await migrateOAAuth();
    await migrateFreshmanAuth();
  }

  Future<void> migrateOAAuth() async {
    final kvBox = HiveBoxInit.settings;
    final credentialBox = HiveBoxInit.credentials;
    final dynamic account = kvBox.get("/auth/currentUsername");
    final dynamic password = kvBox.get("/auth/ssoPassword");
    if (account is String && password is String) {
      credentialBox.put("/credential/oa", OACredential(account, password));
      kvBox.delete("/auth/currentUsername");
      kvBox.delete("/auth/ssoPassword");
    }
  }

  Future<void> migrateFreshmanAuth() async {
    final kvBox = HiveBoxInit.settings;
    final dynamic account = kvBox.get("/freshman/auth/account");
    final dynamic password = kvBox.get("/freshman/auth/secret");
    final credentialBox = HiveBoxInit.credentials;
    if (account is String && password is String) {
      credentialBox.put("/credential/oa", OACredential(account, password));
      kvBox.delete("/freshman/auth/account");
      kvBox.delete("/freshman/auth/secret");
    }
  }
}
