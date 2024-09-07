import 'package:objectbox/objectbox.dart';

@Entity()
class StatsRoute {
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
}
