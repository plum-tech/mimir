import 'package:objectbox/objectbox.dart';

import 'stats.dart';

@Entity()
class StatsRoute implements StatsEntry {
  @Id()
  int id;
  final String route;
  @Property(type: PropertyType.date)
  final DateTime time;

  StatsRoute({
    this.id = 0,
    required this.route,
    required this.time,
  });

  @override
  Map<String, dynamic> toPayload() => {
        "category": "app_route",
        "data": {
          "route": route,
          "time": time.toIso8601String(),
        }
      };
}
