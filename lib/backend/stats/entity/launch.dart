import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

import 'stats.dart';

part "launch.g.dart";

@Entity()
@JsonSerializable(createFactory: false)
class StatsLaunch implements StatsEntry {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  final DateTime launchTime;
  @Property(type: PropertyType.date)
  final DateTime lastHeartbeatTime;

  StatsLaunch({
    this.id = 0,
    required this.launchTime,
    required this.lastHeartbeatTime,
  });

  @override
  Map<String, dynamic> toJson() => _$StatsLaunchToJson(this);
}
