import 'package:objectbox/objectbox.dart';

import 'stats.dart';

@Entity()
class StatsFeatureUsage implements StatsEntry {
  @Id()
  int id;
  final String feature;
  final String result;
  @Property(type: PropertyType.date)
  final DateTime time;

  StatsFeatureUsage({
    this.id = 0,
    required this.feature,
    this.result = "",
    required this.time,
  });

  @override
  Map<String, dynamic> toPayload() => {
        "category": "app_feature",
        "data": {
          "feature": feature,
          "time": time.toIso8601String(),
          "result": result,
        }
      };
}
