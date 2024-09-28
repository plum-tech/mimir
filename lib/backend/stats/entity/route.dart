import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part "route.g.dart";

@Entity()
@JsonSerializable(createFactory: false)
class StatsAppRoute {
  @Id()
  int id;
  final String route;
  @Property(type: PropertyType.date)
  final DateTime time;

  StatsAppRoute({
    this.id = 0,
    required this.route,
    required this.time,
  });

  Map<String, dynamic> toJson() => _$StatsAppRouteToJson(this);
}
