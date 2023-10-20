import 'package:json_annotation/json_annotation.dart';

part 'background.g.dart';

@JsonSerializable()
class BackgroundImage {
  @JsonKey()
  final String path;

  const BackgroundImage({
    required this.path,
  });

  factory BackgroundImage.fromJson(Map<String, dynamic> json) => _$BackgroundImageFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundImageToJson(this);
}
