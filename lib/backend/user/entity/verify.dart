import 'package:json_annotation/json_annotation.dart';

part 'verify.g.dart';

@JsonSerializable(createToJson: false)
class MimirAuthMethods {
  @JsonKey(name: "school-id")
  final bool? schoolId;

  const MimirAuthMethods({
    required this.schoolId,
  });

  factory MimirAuthMethods.fromJson(Map<String, dynamic> json) => _$MimirAuthMethodsFromJson(json);
}
