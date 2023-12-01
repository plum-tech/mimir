import 'package:version/version.dart';

enum MigrationPhrase {
  beforeHive,
  afterHive,
}

/// Migration happens after Hive is initialized, but before all other initializations.
/// If the interval is long enough, each migration between two versions will be performed in sequence.
abstract class Migration {
  /// Perform the migration for a specific version.
  Future<void> perform(MigrationPhrase phrase);

  Migration operator +(Migration then) => ChainedMigration([this, then]);
}

class ChainedMigration extends Migration {
  final List<Migration> migrations;

  ChainedMigration(this.migrations);

  @override
  Future<void> perform(MigrationPhrase phrase) async {
    for (final migration in migrations) {
      await migration.perform(phrase);
    }
  }
}

class _MigrationEntry implements Comparable<_MigrationEntry> {
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
  void addWhen(Version version, {required Migration perform}) {
    _migrations.add(_MigrationEntry(version, perform));
  }

  /// [from] is exclusive.
  /// [to] is inclusive.
  List<Migration> collectBetween(Version from, Version to) {
    _migrations.sort();
    int start = _migrations.indexWhere((m) => m.version == from);
    if (start > 0 && start <= _migrations.length) {
      return _migrations.sublist(start).map((e) => e.migration).toList();
    } else {
      return [];
    }
  }
}
