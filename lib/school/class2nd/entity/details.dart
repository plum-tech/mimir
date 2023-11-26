import 'package:sit/storage/hive/type_id.dart';

part 'details.g.dart';

@HiveType(typeId: HiveTypeClass2nd.activityDetails)
class Class2ndActivityDetails {
  /// Activity id
  @HiveField(0)
  final int id;

  /// Activity title
  @HiveField(1)
  final String title;

  /// Activity start time
  @HiveField(2)
  final DateTime startTime;

  /// Sign start time
  @HiveField(3)
  final DateTime signStartTime;

  /// Sign end time
  @HiveField(4)
  final DateTime signEndTime;

  /// Place
  @HiveField(5)
  final String? place;

  /// Duration
  @HiveField(6)
  final String? duration;

  /// Activity manager
  @HiveField(7)
  final String? principal;

  /// Manager yellow_pages(phone)
  @HiveField(8)
  final String? contactInfo;

  /// Activity organizer
  @HiveField(9)
  final String? organizer;

  /// Activity undertaker
  @HiveField(10)
  final String? undertaker;

  /// Description in text.
  @HiveField(11)
  final String? description;

  const Class2ndActivityDetails({
    required this.id,
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
    this.description,
  });

  @override
  String toString() {
    return {
      "id": id,
      "title": title,
      "startTime": startTime,
      "signStartTime": signStartTime,
      "signEndTime": signEndTime,
      "place": place,
      "duration": duration,
      "principal": principal,
      "contactInfo": contactInfo,
      "organizer": organizer,
      "undertaker": undertaker,
      "description": description,
    }.toString();
  }
}
