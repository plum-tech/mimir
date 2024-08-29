import 'package:json_annotation/json_annotation.dart';

part 'verify.g.dart';

@JsonSerializable(createToJson: false)
class MimirVerifyMethods {
  @JsonKey(name: "school-id")
  final bool schoolId;

  const MimirVerifyMethods({
    required this.schoolId,
  });

  factory MimirVerifyMethods.fromJson(Map<String, dynamic> json) => _$MimirVerifyMethodsFromJson(json);
}
