import 'package:easy_localization/easy_localization.dart';

class CredentialsErrorType {
  final String type;

  const CredentialsErrorType._(this.type);

  static const //
      accountPassword = CredentialsErrorType._("accountPassword"),
      captcha = CredentialsErrorType._("captcha"),
      frozen = CredentialsErrorType._("frozen"),
      locked = CredentialsErrorType._("locked");
  static const //
      oaFrozen = CredentialsErrorType._("oa-frozen"),
      oaLocked = CredentialsErrorType._("oa-locked"),
      oaIncompleteUserInfo = CredentialsErrorType._("oa-incompleteUserInfo");

  String l10n() => "credentials.error.$type".tr();
}

class CredentialsException implements Exception {
  final CredentialsErrorType type;
  final String? message;

  const CredentialsException({
    required this.type,
    this.message,
  });

  @override
  String toString() {
    final message = this.message;
    if (message == null) return "CredentialsException";
    return "CredentialsException: $type $message";
  }
}
