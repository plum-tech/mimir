import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'bulletin.g.dart';

String _trim(String s) => s.trim();
String _randHash(String? s) => s ?? const Uuid().v4();

@JsonSerializable()
@CopyWith(skipFields: true)
class MimirBulletin {
  final String id;
  @JsonKey(fromJson: _randHash)
  final String hash;
  final DateTime createdAt;
  @JsonKey(fromJson: _trim)
  final String short;
  @JsonKey(fromJson: _trim)
  final String text;
  @JsonKey(fromJson: _trim)
  final String content;

  const MimirBulletin({
    required this.id,
    required this.hash,
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
      "hash": hash,
      "createdAt": createdAt,
      "short": short,
      "text": text,
      "content": content,
    }.toString();
  }

  bool get isEmpty => short.isEmpty && content.isEmpty && text.isEmpty;
}
