import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

import 'stats.dart';

part "feature.g.dart";

@Entity()
@JsonSerializable(createFactory: false)
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
  Map<String, dynamic> toJson() => _$StatsFeatureUsageToJson(this);
}
