import 'package:sit/hive/type_id.dart';

part 'details.g.dart';

@HiveType(typeId: HiveTypeClass2nd.activityDetails)
class Class2ndActivityDetails {
  /// Activity id
  @HiveField(0)
  final int id;

  /// Category id
  @HiveField(1)
  final int category;

  /// Activity title
  @HiveField(2)
  final String title;

  /// Activity start time
  @HiveField(3)
  final DateTime startTime;

  /// Sign start time
  @HiveField(4)
  final DateTime signStartTime;

  /// Sign end time
  @HiveField(5)
  final DateTime signEndTime;

  /// Place
  @HiveField(6)
  final String? place;

  /// Duration
  @HiveField(7)
  final String? duration;

  /// Activity manager
  @HiveField(8)
  final String? principal;

  /// Manager yellow_pages(phone)
  @HiveField(9)
  final String? contactInfo;

  /// Activity organizer
  @HiveField(10)
  final String? organizer;

  /// Activity undertaker
  @HiveField(11)
  final String? undertaker;

  /// Description in text[]
  @HiveField(12)
  final String? description;

  const Class2ndActivityDetails(
      this.id,
      this.category,
      this.title,
      this.startTime,
      this.signStartTime,
      this.signEndTime,
      this.place,
      this.duration,
      this.principal,
      this.contactInfo,
      this.organizer,
      this.undertaker,
      this.description);

  const Class2ndActivityDetails.named(
      {required this.id,
      required this.category,
      required this.title,
      required this.startTime,
      required this.signStartTime,
      required this.signEndTime,
      this.place,
      this.duration,
      this.principal,
      this.contactInfo,
      this.organizer,
      this.undertaker,
      this.description});

  @override
  String toString() {
    return 'ActivityDetail{id: $id, category: $category, title: $title, '
        'startTime: $startTime, signStartTime: $signStartTime, '
        'signEndTime: $signEndTime, place: $place, duration: $duration,'
        'principal: $principal, contactInfo: $contactInfo, organizer: $organizer,'
        ' undertaker: $undertaker, description: $description}';
  }
}
