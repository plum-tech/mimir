import 'dart:async';

import 'package:version/version.dart';

enum MigrationPhrase {
  beforeHive,
  afterHive,
  afterInitStorage,
}

/// Migration happens after Hive is initialized, but before all other initializations.
/// If the interval is long enough, each migration between two versions will be performed in sequence.
abstract class Migration {
  const Migration();

  factory Migration.run(FutureOr<void> Function(MigrationPhrase phrase) func) {
    return _FunctionalMigration(func);
  }

  /// Perform the migration for a specific version.
  Future<void> perform(MigrationPhrase phrase);

  Migration operator +(Migration then) => ChainedMigration([this, then]);
}

class _FunctionalMigration extends Migration {
  final FutureOr<void> Function(MigrationPhrase phrase) func;

  const _FunctionalMigration(this.func);

  @override
  Future<void> perform(MigrationPhrase phrase) async {
    await func(phrase);
  }
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
    return version.compareTo(other.version);
  }
}

class MigrationManager {
  final List<_MigrationEntry> _migrations = [];

  /// Add a migration when
  void addWhen(Version version, {required Migration perform}) {
    _migrations.add(_MigrationEntry(version, perform));
  }

  /// [from] is exclusive.
  /// [current] is inclusive.
  List<Migration> collectBetween(Version from, Version current) {
    if (from == current) return [];
    _migrations.sort();
    final involved = _migrations.where((m) {
      // from: 2.3.2, m: 2.3.1 => no
      // from: 2.3.2, m: 2.3.2 => yes
      // from: 2.3.2, m: 2.4.0 => yes
      if (from <= m.version) {
        return true;
      }
      // current: 2.4.0, m: 2.3.2 => no
      // current: 2.4.0, m: 2.4.0 => yes
      // from: 2.4.0, current: 2.4.0, m: 2.4.0 => filter at first
      // from: 2.3.2, current: 2.4.0, m: 2.4.0 => handled upper
      if (current <= m.version) {
        return true;
      }
      return false;
    }).toList();
    return involved.map((e) => e.migration).toList();
  }
}
