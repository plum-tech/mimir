import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part "cell_style.g.dart";

@CopyWith(skipFields: true)
@JsonSerializable()
class CourseCellStyle {
  @JsonKey()
  final bool showTeachers;
  @JsonKey()
  final bool grayOutTakenLessons;
  @JsonKey()
  final bool harmonizeWithThemeColor;
  @JsonKey()
  final double alpha;

  const CourseCellStyle({
    this.showTeachers = true,
    this.grayOutTakenLessons = false,
    this.harmonizeWithThemeColor = true,
    this.alpha = 1.0,
  });

  factory CourseCellStyle.fromJson(Map<String, dynamic> json) => _$CourseCellStyleFromJson(json);

  Map<String, dynamic> toJson() => _$CourseCellStyleToJson(this);
}
