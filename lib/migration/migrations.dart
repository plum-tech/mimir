import 'package:mimir/r.dart';
import 'package:version/version.dart';

import 'all/cache.dart';
import 'foundation.dart';

class Migrations {
  static final _manager = MigrationManager();
  static Migration? _onNullVersion;

  static void init() {
    R.v1_0_0 << ClearCacheMigration;
  }

  static Future<void> perform({required Version? from, required Version? to}) async {
    if (from == null) {
      await _onNullVersion?.perform();
    } else {
      if (to != null) {
        await _manager.upgrade(from, to);
      }
    }
  }
}

extension _MigrationEx on Version {
  void operator <<(Migration migration) {
    Migrations._manager.when(this, perform: migration);
  }
}
