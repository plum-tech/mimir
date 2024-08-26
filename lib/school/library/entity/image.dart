import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'image.g.dart';

@JsonSerializable()
@HiveType(typeId: CacheHiveType.libraryBookImage)
class BookImage {
  @HiveField(0)
  final String isbn;
  @JsonKey(name: 'coverlink')
  @HiveField(1)
  final String coverUrl;
  @JsonKey(name: 'resourceLink')
  @HiveField(2)
  final String resourceUrl;
  @HiveField(3)
  final int status;

  const BookImage({
    required this.isbn,
    required this.coverUrl,
    required this.resourceUrl,
    required this.status,
  });

  factory BookImage.fromJson(Map<String, dynamic> json) => _$BookImageFromJson(json);

  Map<String, dynamic> toJson() => _$BookImageToJson(this);
}
