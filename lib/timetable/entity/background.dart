import 'package:json_annotation/json_annotation.dart';

part 'background.g.dart';

@JsonSerializable()
class BackgroundImage {
  @JsonKey()
  final String path;
  @JsonKey()
  final double opacity;

  const BackgroundImage({
    required this.path,
    this.opacity = 1.0,
  });

  factory BackgroundImage.fromJson(Map<String, dynamic> json) => _$BackgroundImageFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundImageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
