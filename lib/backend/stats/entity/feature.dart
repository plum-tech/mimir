import 'package:objectbox/objectbox.dart';

@Entity()
class StatsFeatureUsage {
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
}
