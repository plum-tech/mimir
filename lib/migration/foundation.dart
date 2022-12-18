import 'package:version/version.dart';

/// Migration happens after Hive is initialized, but before all other initializations.
/// If the interval is long enough, each migration between two versions will be performed in sequence.
abstract class Migration {
  /// Perform the migration for a specific version.
  Future<void> perform();

  Migration operator +(Migration then) => _CompoundMigration(this, then);
}

class _CompoundMigration extends Migration {
  final Migration first;
  final Migration then;

  _CompoundMigration(this.first, this.then);

  @override
  Future<void> perform() async {
    await first.perform();
    await then.perform();
  }
}

class _MigrationEntry extends Comparable<_MigrationEntry> {
  final Version version;
  final Migration migration;

  _MigrationEntry(this.version, this.migration);

  @override
  int compareTo(_MigrationEntry other) {
    throw version.compareTo(other.version);
  }
}

class MigrationManager {
  final List<_MigrationEntry> _migrations = [];

  /// Add a migration when
  void when(Version version, {required Migration perform}) {
    _migrations.add(_MigrationEntry(version, perform));
  }

  /// [from] is exclusive.
  /// [to] is inclusive.
  List<Migration> _collectBetween(Version from, Version to) {
    _migrations.sort();
    int start = _migrations.indexWhere((m) => m.version == from);
    if (start > 0 && start <= _migrations.length) {
      return _migrations.sublist(start).map((e) => e.migration).toList();
    } else {
      return [];
    }
  }

  Future<void> upgrade(Version from, Version to) async {
    final migrations = _collectBetween(from, to);
    for (final migration in migrations) {
      await migration.perform();
    }
  }
}
