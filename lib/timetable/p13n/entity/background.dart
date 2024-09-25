import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/painting.dart';
import 'package:json_annotation/json_annotation.dart';

part 'background.g.dart';

@JsonSerializable()
@CopyWith(skipFields: true)
class BackgroundImage {
  @JsonKey()
  final String path;
  @JsonKey()
  final double opacity;
  @JsonKey()
  final bool repeat;
  @JsonKey()
  final bool antialias;
  @JsonKey()
  final bool hidden;
  @JsonKey()
  final bool immersive;

  const BackgroundImage({
    required this.path,
    this.opacity = 1.0,
    this.repeat = true,
    this.antialias = true,
    this.hidden = false,
    this.immersive = false,
  });

  const BackgroundImage.disabled({
    this.opacity = 1.0,
    this.repeat = true,
    this.antialias = true,
    this.hidden = true,
    this.immersive = false,
  }) : path = "";

  bool get enabled => path.isNotEmpty && !hidden;

  ImageRepeat get imageRepeat => repeat ? ImageRepeat.repeat : ImageRepeat.noRepeat;

  FilterQuality get filterQuality => antialias ? FilterQuality.low : FilterQuality.none;

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
            antialias == other.antialias &&
            hidden == other.hidden;
  }

  @override
  int get hashCode => Object.hash(
        path,
        opacity,
        repeat,
        antialias,
        hidden,
      );

  @override
  String toString() {
    return toJson().toString();
  }
}
