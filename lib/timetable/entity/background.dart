import 'package:json_annotation/json_annotation.dart';

part 'background.g.dart';

@JsonSerializable()
class BackgroundImage {
  @JsonKey()
  final String path;
  @JsonKey()
  final double opacity;
  @JsonKey()
  final bool repeat;
  @JsonKey()
  final bool antialias;

  const BackgroundImage({
    required this.path,
    this.opacity = 1.0,
    this.repeat = true,
    this.antialias = true,
  });

  factory BackgroundImage.fromJson(Map<String, dynamic> json) => _$BackgroundImageFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundImageToJson(this);

  BackgroundImage copyWith({
    String? path,
    double? opacity,
    bool? repeat,
    bool? antialias,
  }) {
    return BackgroundImage(
      path: path ?? this.path,
      opacity: opacity ?? this.opacity,
      repeat: repeat ?? this.repeat,
      antialias: antialias ?? this.antialias,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
