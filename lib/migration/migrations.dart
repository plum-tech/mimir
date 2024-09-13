import 'package:flutter/foundation.dart';
import 'package:mimir/files.dart';
import 'package:mimir/settings/entity/proxy.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/utils/hive.dart';
import 'package:version/version.dart';

import 'foundation.dart';

enum MigrationPhrase {
  beforeHive,
  afterHive,
  afterInitStorage,
}

typedef MimirMigration = Migration<MigrationPhrase>;
typedef MimirMigrationManager = MigrationManager<MigrationPhrase>;

class Migrations {
  static final _manager = MimirMigrationManager();
  static Migration<MigrationPhrase>? _onNullVersion;

  static void init() {
    Version(1, 0, 0) <<
        MimirMigration.run((phrase) async {
          if (phrase == MigrationPhrase.afterHive) {
            await HiveInit.clearCache();
          }
        });
    Version(2, 4, 0) <<
        MimirMigration.run((phrase) async {
          if (kIsWeb) return;
          switch (phrase) {
            case MigrationPhrase.beforeHive:
              final oldTimetableBackgroundFi = Files.user.subFile("timetable", "background.img");
              final oldExists = await oldTimetableBackgroundFi.exists();
              final newExists = await Files.timetable.backgroundFile.exists();
              if (oldExists && !newExists) {
                await oldTimetableBackgroundFi.copy(Files.timetable.backgroundFile.path);
                await oldTimetableBackgroundFi.delete();
              }
            case MigrationPhrase.afterHive:
              await HiveInit.ywb.clear();
              // proxy
              final proxyBox = Settings.proxy.box;
              for (final cat in ProxyCat.values) {
                // if the user has already added new proxy profile, ignore this
                if (Settings.proxy.getProfileOf(cat) != null) continue;
                final address = proxyBox.safeGet<String>("/proxy/${cat.name}/address");
                final addressUri = address != null ? Uri.tryParse(address) : null;
                final enabled = proxyBox.safeGet<bool>("/proxy/${cat.name}/enabled");
                final mode = proxyBox.safeGet<ProxyMode>("/proxy/${cat.name}/proxyMode");
                if (addressUri != null && !cat.isDefaultUri(addressUri)) {
                  await Settings.proxy.setProfileOf(
                    cat,
                    ProxyProfile(
                      address: addressUri,
                      enabled: enabled ?? true,
                      mode: mode ?? ProxyMode.schoolOnly,
                    ),
                  );
                }
                await proxyBox.delete("/proxy/${cat.name}/address");
                await proxyBox.delete("/proxy/${cat.name}/enabled");
                await proxyBox.delete("/proxy/${cat.name}/proxyMode");
              }
            case MigrationPhrase.afterInitStorage:
          }
        });
    Version(2, 5, 1) <<
        MimirMigration.run((phrase) async {
          if (phrase == MigrationPhrase.afterHive) {
            // Refresh timetable json
            final rows = TimetableInit.storage.timetable.getRows();
            for (final (:id, :row) in rows) {
              TimetableInit.storage.timetable[id] = row;
            }
          }
        });
    Version(2, 6, 0) <<
        MimirMigration.run((phrase) async {
          if (phrase == MigrationPhrase.afterHive) {
            // Refresh timetable json
            for (final (:id, :row) in TimetableInit.storage.timetable.getRows()) {
              TimetableInit.storage.timetable[id] = row;
            }
            // Refresh palette json
            for (final (:id, :row) in TimetableInit.storage.palette.getRows()) {
              TimetableInit.storage.palette[id] = row;
            }
          }
        });
  }

  static MigrationMatch match({
    required Version? from,
    required Version? to,
  }) {
    final result = <MimirMigration>[];
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
  final List<MimirMigration> _migrations;

  const MigrationMatch(this._migrations);

  Future<void> perform(MigrationPhrase phrase) async {
    try {
      for (final migration in _migrations) {
        await migration.perform(phrase);
      }
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
    }
  }
}

extension _MigrationEx on Version {
  void operator <<(MimirMigration migration) {
    Migrations._manager.addWhen(this, perform: migration);
  }
}
