import 'dart:async';

import 'package:version/version.dart';

/// Migration happens after Hive is initialized, but before all other initializations.
/// If the interval is long enough, each migration between two versions will be performed in sequence.
abstract class Migration<TPhrase> {
  const Migration();

  factory Migration.run(FutureOr<void> Function(TPhrase phrase) func) {
    return _FunctionalMigration(func);
  }

  /// Perform the migration for a specific version.
  Future<void> perform(TPhrase phrase);

  Migration operator +(Migration then) => ChainedMigration([this, then]);
}

class _FunctionalMigration<TPhrase> extends Migration<TPhrase> {
  final FutureOr<void> Function(TPhrase phrase) func;

  const _FunctionalMigration(this.func);

  @override
  Future<void> perform(TPhrase phrase) async {
    await func(phrase);
  }
}

class ChainedMigration<TPhrase> extends Migration<TPhrase> {
  final List<Migration> migrations;

  ChainedMigration(this.migrations);

  @override
  Future<void> perform(TPhrase phrase) async {
    for (final migration in migrations) {
      await migration.perform(phrase);
    }
  }
}

class _MigrationEntry<TPhrase> implements Comparable<_MigrationEntry<TPhrase>> {
  final Version version;
  final Migration<TPhrase> migration;

  _MigrationEntry(this.version, this.migration);

  @override
  int compareTo(_MigrationEntry<TPhrase> other) {
    return version.compareTo(other.version);
  }
}

class MigrationManager<TPhrase> {
  final List<_MigrationEntry<TPhrase>> _migrations = [];

  /// Add a migration when
  void addWhen(Version version, {required Migration<TPhrase> perform}) {
    _migrations.add(_MigrationEntry(version, perform));
  }

  /// [from] is exclusive.
  /// [current] is inclusive.
  List<Migration<TPhrase>> collectBetween(Version from, Version current) {
    if (from == current) return [];
    _migrations.sort();
    final involved = _migrations.where((m) {
      // from: 2.3.2, m: 2.3.1 => no
      // from: 2.3.2, m: 2.3.2 => yes
      // from: 2.3.2, m: 2.4.0 => yes
      if (from < m.version) {
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
