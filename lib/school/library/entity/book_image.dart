import 'package:json_annotation/json_annotation.dart';

part 'book_image.g.dart';

@JsonSerializable()
class BookImage {
  final String isbn;
  @JsonKey(name: 'coverlink')
  final String coverLink;
  final String resourceLink;
  final int status;

  const BookImage(this.isbn, this.coverLink, this.resourceLink, this.status);

  factory BookImage.fromJson(Map<String, dynamic> json) => _$BookImageFromJson(json);

  Map<String, dynamic> toJson() => _$BookImageToJson(this);
}
