import 'package:version/version.dart';

import 'all/cache.dart';
import 'foundation.dart';

class Migrations {
  static final _manager = MigrationManager();
  static Migration? _onNullVersion;

  static void init() {
    Version(1, 0, 0) << ClearCacheMigration;
  }

  static MigrationMatch match({
    required Version? from,
    required Version? to,
  }) {
    final result = <Migration>[];
    if (from == null) {
      final onNullVersion = _onNullVersion;
      if (onNullVersion != null) {
        result.add(onNullVersion);
      }
    } else if (to != null) {
      final all = _manager.collectBetween(from, to);
      result.addAll(all);
    }
    return MigrationMatch(result);
  }
}

class MigrationMatch {
  final List<Migration> _migrations;

  const MigrationMatch(this._migrations);

  Future<void> perform(MigrationPhrase phrase) async {
    for (final migration in _migrations) {
      await migration.perform(phrase);
    }
  }
}

extension _MigrationEx on Version {
  void operator <<(Migration migration) {
    Migrations._manager.addWhen(this, perform: migration);
  }
}
