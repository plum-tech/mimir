import 'dart:async';

import 'package:version/version.dart';

enum MigrationPhrase {
  beforeHive,
  afterHive,
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
  /// [to] is inclusive.
  List<Migration> collectBetween(Version from, Version to) {
    _migrations.sort();
    final involved = _migrations.where((m) => from <= m.version  && m.version <= to).toList();
    return involved.map((e) => e.migration).toList();
  }
}
