import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class BookImage {
  final String isbn;
  @JsonKey(name: 'coverlink')
  final String coverLink;
  final String resourceLink;
  final int status;

  const BookImage({
    required this.isbn,
    required this.coverLink,
    required this.resourceLink,
    required this.status,
  });

  factory BookImage.fromJson(Map<String, dynamic> json) => _$BookImageFromJson(json);

  Map<String, dynamic> toJson() => _$BookImageToJson(this);
}
