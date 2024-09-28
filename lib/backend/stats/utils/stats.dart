import 'package:flutter/foundation.dart';
import 'package:mimir/backend/stats/entity/route.dart';

import '../entity/feature.dart';
import '../init.dart';

class Stats {
  static String? lastRoute;

  static void route(Uri uri) {
    final route = uri.toString();
    if (route == lastRoute) {
      return;
    }
    lastRoute = route;
    final time = DateTime.now();
    final row = StatsAppRoute(
      route: route.toString(),
      time: time,
    );
    final id = StatsInit.storage.route.put(row);
    debugPrint('[${time.toString()}] On route #$id: "$route"');
  }

  static void feature(String feature, [String? result]) {
    final time = DateTime.now();
    final row = StatsAppFeature(
      feature: feature,
      result: result ?? "",
      time: time,
    );
    final id = StatsInit.storage.feature.put(row);
    debugPrint('[${time.toString()}] On feature #$id: "$feature"');
  }
}
