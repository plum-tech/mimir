import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

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

  const BackgroundImage.disabled({
    this.opacity = 1.0,
    this.repeat = true,
    this.antialias = true,
  }) : path = "";

  bool get enabled => path.isNotEmpty;

  factory BackgroundImage.fromJson(Map<String, dynamic> json) => _$BackgroundImageFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundImageToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BackgroundImage &&
            runtimeType == other.runtimeType &&
            path == other.path &&
            opacity == other.opacity &&
            repeat == other.repeat &&
            antialias == other.antialias;
  }

  @override
  int get hashCode => hash4(path, opacity, repeat, antialias);

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

  BackgroundImage disabledCopyWith({
    double? opacity,
    bool? repeat,
    bool? antialias,
  }) {
    return BackgroundImage(
      path: "",
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
