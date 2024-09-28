import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part "feature.g.dart";

@Entity()
@JsonSerializable(createFactory: false)
class StatsAppFeature {
  @Id()
  int id;
  final String feature;
  final String result;
  @Property(type: PropertyType.date)
  final DateTime time;

  StatsAppFeature({
    this.id = 0,
    required this.feature,
    this.result = "",
    required this.time,
  });

  Map<String, dynamic> toJson() => _$StatsAppFeatureToJson(this);
}
