import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify.g.dart';

enum MimirAuthMethod {
  schoolId("school-id"),
  eduEmail("edu-email"),
  phoneNumber("phone-number");

  final String id;

  const MimirAuthMethod(this.id);

  String l10n() => "mimir.auth.$name.name".tr();
}

@JsonSerializable(createToJson: false)
class MimirAuthMethods {
  final bool? schoolId;
  final bool? eduEmail;
  final bool? phoneNumber;

  const MimirAuthMethods({
    required this.schoolId,
    required this.eduEmail,
    required this.phoneNumber,
  });

  factory MimirAuthMethods.fromJson(Map<String, dynamic> json) => _$MimirAuthMethodsFromJson(json);

  Set<MimirAuthMethod> get supportedMethods {
    return {
      if (schoolId != null) MimirAuthMethod.schoolId,
      if (eduEmail != null) MimirAuthMethod.eduEmail,
      if (phoneNumber != null) MimirAuthMethod.phoneNumber,
    };
  }

  bool isSupported(MimirAuthMethod method) {
    return supportedMethods.contains(method);
  }

  bool get anySupported => supportedMethods.isNotEmpty;

  Set<MimirAuthMethod> get availableMethods {
    return {
      if (schoolId == true) MimirAuthMethod.schoolId,
      if (eduEmail == true) MimirAuthMethod.eduEmail,
      if (phoneNumber == true) MimirAuthMethod.phoneNumber,
    };
  }

  bool isAvailable(MimirAuthMethod method) {
    return availableMethods.contains(method);
  }

  bool get anyAvailable => availableMethods.isNotEmpty;
}
