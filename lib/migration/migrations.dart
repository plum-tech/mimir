import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mimir/files.dart';
import 'package:mimir/settings/entity/proxy.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/p13n/entity/palette.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/utils/json.dart';
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
    Version(2, 6, 3) <<
        MimirMigration.run((phrase) async {
          if (phrase == MigrationPhrase.afterHive) {
            // migrate timetables and palettes
            () {
              final box = HiveInit.timetable;
              final timetableRows = <Timetable>[];
              final paletteRows = <TimetablePalette>[];
              final keys2Remove = <String>[];

              Timetable? getTimetable(String key) {
                final value = box.safeGet<String>(key);
                if (value == null) return null;
                final obj = decodeJsonObject(value, (obj) => Timetable.fromJson(obj));
                return obj;
              }

              TimetablePalette? getPalette(String key) {
                final value = box.safeGet<String>(key);
                if (value == null) return null;
                final obj = decodeJsonObject(value, (obj) => TimetablePalette.fromJson(obj));
                return obj;
              }

              for (final key in box.keys) {
                if (key is! String) continue;
                if (key.startsWith("/timetable/rows")) {
                  final obj = getTimetable(key);
                  if (obj == null) continue;
                  timetableRows.add(obj);
                  keys2Remove.add(key);
                } else if (key.startsWith("/palette/rows")) {
                  final obj = getPalette(key);
                  if (obj == null) continue;
                  paletteRows.add(obj);
                  keys2Remove.add(key);
                }
              }
              keys2Remove.add("/timetable/lastId");
              keys2Remove.add("/palette/lastId");
              final timetableIdList = timetableRows.map((row) => row.uuid).toList();
              final paletteIdList = paletteRows.map((row) => row.uuid).toList();

              final timetableSelectedId = box.safeGet<int>("/timetable/selectedId");
              final timetableSelected = getTimetable("/timetable/rows/$timetableSelectedId");

              final paletteSelectedId = box.safeGet<int>("/palette/selectedId");
              final paletteSelected = getTimetable("/palette/rows/$paletteSelectedId");

              // -- put --
              if (timetableSelected != null) {
                box.safePut<String>("/timetable/selectedId", timetableSelected.uuid);
              }
              if (paletteSelected != null) {
                box.safePut<String>("/palette/selectedId", paletteSelected.uuid);
              }
              for (final timetable in timetableRows) {
                box.safePut<String>("/timetable/rows/${timetable.uuid}", encodeJsonObject(timetable));
              }
              box.safePut<List<String>>("/timetable/idList", timetableIdList);

              for (final palette in paletteRows) {
                box.safePut<String>("/palette/rows/${palette.uuid}", encodeJsonObject(palette));
              }
              box.safePut<List<String>>("/palette/idList", paletteIdList);

              // -- delete --
              for (final key in keys2Remove) {
                box.delete(key);
              }
            }();
          }
        });
    MigrationPhrase.afterHive <<
        () async {
          return;
        };
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

final _debugTasks = <MigrationPhrase, List<FutureOr<void> Function()>>{};

class MigrationMatch {
  final List<MimirMigration> _migrations;

  MigrationMatch(this._migrations);

  Future<void> perform(MigrationPhrase phrase) async {
    for (final migration in _migrations) {
      try {
        await migration.perform(phrase);
      } catch (error, stackTrace) {
        debugPrintError(error, stackTrace);
      }
    }
    if (kDebugMode) {
      final tasks = _debugTasks[phrase];
      if (tasks == null) return;
      for (final task in tasks) {
        try {
          await task();
        } catch (error, stackTrace) {
          debugPrintError(error, stackTrace);
        }
      }
    }
  }
}

extension _MigrationEx on Version {
  void operator <<(MimirMigration migration) {
    Migrations._manager.addWhen(this, perform: migration);
  }
}

extension _MigrationPhraseEx on MigrationPhrase {
  void operator <<(FutureOr<void> Function() func) {
    var list = _debugTasks[this];
    if (list == null) {
      _debugTasks[this] = list = [];
    }
    list.add(func);
  }
}
