import 'package:json_annotation/json_annotation.dart';

part 'bulletin.g.dart';

@JsonSerializable(createToJson: false)
class MimirBulletin {
  final int id;
  final DateTime createdAt;
  final String content;

  const MimirBulletin({
    required this.id,
    required this.createdAt,
    required this.content,
  });

  factory MimirBulletin.fromJson(Map<String, dynamic> json) => _$MimirBulletinFromJson(json);

  @override
  String toString() {
    return {
      "id": id,
      "createdAt": createdAt,
      "content": content,
    }.toString();
  }
}
