import 'package:mimir/feature/feature.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class StatsFeatureUsage {
  @Id()
  int id;
  final String feature;
  @Property(type: PropertyType.date)
  final DateTime time;

  StatsFeatureUsage({
    this.id = 0,
    required this.feature,
    required this.time,
  });

  factory StatsFeatureUsage.by({
    required AppFeature feature,
    required DateTime time,
  }) {
    return StatsFeatureUsage(
      feature: feature.name,
      time: time,
    );
  }
}
