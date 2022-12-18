// ignore_for_file: non_constant_identifier_names

import 'package:mimir/mimir/mimir.dart';
import 'entities.dart';

void DataAdapterPlugin(Mimir mimir) {
  mimir.registerAdapter(SitTimetableDataAdapter());
  mimir.registerAdapter(SitTimetableWeekDataAdapter());
  mimir.registerAdapter(SitTimetableDayDataAdapter());
  mimir.registerAdapter(SitTimetableLessonDataAdapter());
  mimir.registerAdapter(SitCourseDataAdapter());
}

void DebugPlugin(Mimir mimir) {
  mimir.isDebug = true;
  mimir.registerDebugMigration(Migration.of("SitCourse", (from) {
    final res = Map.of(from);
    res["iconName"] ??= "principle";
    if (from.containsKey("weekIndices")) {
      res["rangedWeekNumbers"] ??= from["weekIndices"];
    }
    res["dayIndex"] ??= 0;
    return res;
  }, to: 0));
}
