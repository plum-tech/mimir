// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart' as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'backend/stats/entity/feature.dart';
import 'backend/stats/entity/launch.dart';
import 'backend/stats/entity/route.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 7792226361634421951),
      name: 'StatsAppFeature',
      lastPropertyId: const obx_int.IdUid(4, 3561405707930862768),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(id: const obx_int.IdUid(1, 7259670557469953127), name: 'id', type: 6, flags: 1),
        obx_int.ModelProperty(id: const obx_int.IdUid(2, 2544432439770724940), name: 'feature', type: 9, flags: 0),
        obx_int.ModelProperty(id: const obx_int.IdUid(3, 5636964894945979034), name: 'result', type: 9, flags: 0),
        obx_int.ModelProperty(id: const obx_int.IdUid(4, 3561405707930862768), name: 'time', type: 10, flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 1752953999712395307),
      name: 'StatsAppLaunch',
      lastPropertyId: const obx_int.IdUid(3, 439394962961432267),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(id: const obx_int.IdUid(1, 430092276803471191), name: 'id', type: 6, flags: 1),
        obx_int.ModelProperty(id: const obx_int.IdUid(2, 700648802499443429), name: 'launchTime', type: 10, flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 439394962961432267), name: 'lastHeartbeatTime', type: 10, flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(6, 3205703056394533494),
      name: 'StatsAppRoute',
      lastPropertyId: const obx_int.IdUid(3, 6211341476201417532),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(id: const obx_int.IdUid(1, 4701626622726963455), name: 'id', type: 6, flags: 1),
        obx_int.ModelProperty(id: const obx_int.IdUid(2, 6954221268779870106), name: 'route', type: 9, flags: 0),
        obx_int.ModelProperty(id: const obx_int.IdUid(3, 6211341476201417532), name: 'time', type: 10, flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(6, 3205703056394533494),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [6058686906110423483, 6860077869163213812, 3688717735845025595],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        8567821803968552595,
        6258818122600997136,
        3615904521094794642,
        1456794932391410454,
        1088320578842355463,
        6229011439275914211,
        6558364299568351246,
        5919874536508612063,
        2068107934154271660,
        4710628089873159767
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    StatsAppFeature: obx_int.EntityDefinition<StatsAppFeature>(
        model: _entities[0],
        toOneRelations: (StatsAppFeature object) => [],
        toManyRelations: (StatsAppFeature object) => {},
        getId: (StatsAppFeature object) => object.id,
        setId: (StatsAppFeature object, int id) {
          object.id = id;
        },
        objectToFB: (StatsAppFeature object, fb.Builder fbb) {
          final featureOffset = fbb.writeString(object.feature);
          final resultOffset = fbb.writeString(object.result);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, featureOffset);
          fbb.addOffset(2, resultOffset);
          fbb.addInt64(3, object.time.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final featureParam = const fb.StringReader(asciiOptimization: true).vTableGet(buffer, rootOffset, 6, '');
          final resultParam = const fb.StringReader(asciiOptimization: true).vTableGet(buffer, rootOffset, 8, '');
          final timeParam =
              DateTime.fromMillisecondsSinceEpoch(const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final object = StatsAppFeature(id: idParam, feature: featureParam, result: resultParam, time: timeParam);

          return object;
        }),
    StatsAppLaunch: obx_int.EntityDefinition<StatsAppLaunch>(
        model: _entities[1],
        toOneRelations: (StatsAppLaunch object) => [],
        toManyRelations: (StatsAppLaunch object) => {},
        getId: (StatsAppLaunch object) => object.id,
        setId: (StatsAppLaunch object, int id) {
          object.id = id;
        },
        objectToFB: (StatsAppLaunch object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.launchTime.millisecondsSinceEpoch);
          fbb.addInt64(2, object.lastHeartbeatTime.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final launchTimeParam =
              DateTime.fromMillisecondsSinceEpoch(const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final lastHeartbeatTimeParam =
              DateTime.fromMillisecondsSinceEpoch(const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object =
              StatsAppLaunch(id: idParam, launchTime: launchTimeParam, lastHeartbeatTime: lastHeartbeatTimeParam);

          return object;
        }),
    StatsAppRoute: obx_int.EntityDefinition<StatsAppRoute>(
        model: _entities[2],
        toOneRelations: (StatsAppRoute object) => [],
        toManyRelations: (StatsAppRoute object) => {},
        getId: (StatsAppRoute object) => object.id,
        setId: (StatsAppRoute object, int id) {
          object.id = id;
        },
        objectToFB: (StatsAppRoute object, fb.Builder fbb) {
          final routeOffset = fbb.writeString(object.route);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, routeOffset);
          fbb.addInt64(2, object.time.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final routeParam = const fb.StringReader(asciiOptimization: true).vTableGet(buffer, rootOffset, 6, '');
          final timeParam =
              DateTime.fromMillisecondsSinceEpoch(const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object = StatsAppRoute(id: idParam, route: routeParam, time: timeParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [StatsAppFeature] entity fields to define ObjectBox queries.
class StatsAppFeature_ {
  /// See [StatsAppFeature.id].
  static final id = obx.QueryIntegerProperty<StatsAppFeature>(_entities[0].properties[0]);

  /// See [StatsAppFeature.feature].
  static final feature = obx.QueryStringProperty<StatsAppFeature>(_entities[0].properties[1]);

  /// See [StatsAppFeature.result].
  static final result = obx.QueryStringProperty<StatsAppFeature>(_entities[0].properties[2]);

  /// See [StatsAppFeature.time].
  static final time = obx.QueryDateProperty<StatsAppFeature>(_entities[0].properties[3]);
}

/// [StatsAppLaunch] entity fields to define ObjectBox queries.
class StatsAppLaunch_ {
  /// See [StatsAppLaunch.id].
  static final id = obx.QueryIntegerProperty<StatsAppLaunch>(_entities[1].properties[0]);

  /// See [StatsAppLaunch.launchTime].
  static final launchTime = obx.QueryDateProperty<StatsAppLaunch>(_entities[1].properties[1]);

  /// See [StatsAppLaunch.lastHeartbeatTime].
  static final lastHeartbeatTime = obx.QueryDateProperty<StatsAppLaunch>(_entities[1].properties[2]);
}

/// [StatsAppRoute] entity fields to define ObjectBox queries.
class StatsAppRoute_ {
  /// See [StatsAppRoute.id].
  static final id = obx.QueryIntegerProperty<StatsAppRoute>(_entities[2].properties[0]);

  /// See [StatsAppRoute.route].
  static final route = obx.QueryStringProperty<StatsAppRoute>(_entities[2].properties[1]);

  /// See [StatsAppRoute.time].
  static final time = obx.QueryDateProperty<StatsAppRoute>(_entities[2].properties[2]);
}
