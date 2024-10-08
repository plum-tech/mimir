import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bulletin.g.dart';

String _trim(String s) => s.trim();

@JsonSerializable()
@CopyWith(skipFields: true)
class MimirBulletin {
  final String id;
  final DateTime createdAt;
  @JsonKey(fromJson: _trim)
  final String short;
  @JsonKey(fromJson: _trim)
  final String text;
  @JsonKey(fromJson: _trim)
  final String content;

  const MimirBulletin({
    required this.id,
    required this.createdAt,
    required this.short,
    required this.text,
    required this.content,
  });

  factory MimirBulletin.fromJson(Map<String, dynamic> json) => _$MimirBulletinFromJson(json);

  Map<String, dynamic> toJson() => _$MimirBulletinToJson(this);

  @override
  String toString() {
    return {
      "id": id,
      "createdAt": createdAt,
      "short": short,
      "text": text,
      "content": content,
    }.toString();
  }

  bool get isEmpty => short.isEmpty && content.isEmpty && text.isEmpty;
}
