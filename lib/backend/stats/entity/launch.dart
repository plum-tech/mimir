import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part "launch.g.dart";

@Entity()
@JsonSerializable(createFactory: false)
class StatsAppLaunch {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  final DateTime launchTime;
  @Property(type: PropertyType.date)
  final DateTime lastHeartbeatTime;

  StatsAppLaunch({
    this.id = 0,
    required this.launchTime,
    required this.lastHeartbeatTime,
  });

  Map<String, dynamic> toJson() => _$StatsAppLaunchToJson(this);
}
