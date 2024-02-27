class CredentialsErrorType {
  final String type;

  const CredentialsErrorType(this.type);

  static const accountPassword = CredentialsErrorType("accountPassword"),
      captcha = CredentialsErrorType("captcha"),
      frozen = CredentialsErrorType("frozen"),
      locked = CredentialsErrorType("locked"),
      incompleteUserInfo = CredentialsErrorType("incompleteUserInfo");
}

class CredentialsException implements Exception {
  final CredentialsErrorType type;
  final String? message;

  const CredentialsException({
    required this.type,
    this.message,
  });
}
