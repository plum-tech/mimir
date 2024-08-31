import 'package:json_annotation/json_annotation.dart';

part 'verify.g.dart';

@JsonSerializable(createToJson: false)
class MimirAuthMethods {
  @JsonKey(name: "school-id")
  final bool? schoolId;
  @JsonKey(name: "edu-email")
  final bool? eduEmail;
  @JsonKey(name: "phone-number")
  final bool? phoneNumber;

  const MimirAuthMethods({
    required this.schoolId,
    required this.eduEmail,
    required this.phoneNumber,
  });

  factory MimirAuthMethods.fromJson(Map<String, dynamic> json) => _$MimirAuthMethodsFromJson(json);
}
