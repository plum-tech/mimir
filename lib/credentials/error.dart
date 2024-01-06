enum CredentialsErrorType {
  accountPassword,
  captcha,
  frozen,
  locked,
  incompleteUserInfo,
}

class CredentialsException implements Exception {
  final CredentialsErrorType type;
  final String? message;

  const CredentialsException({
    required this.type,
    this.message,
  });
}
