import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

import 'stats.dart';

part "route.g.dart";

@Entity()
@JsonSerializable(createFactory: false)
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
  Map<String, dynamic> toJson() => _$StatsRouteToJson(this);
}
