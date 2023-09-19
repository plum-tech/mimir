// TODO: I18n msg?
enum OaCredentialsErrorType {
  accountPassword,
  captcha,
  frozen,
}

class YwbCredentialsException implements Exception {
  final String message;

  const YwbCredentialsException({
    required this.message,
  });
}

/// 认证失败
class OaCredentialsException implements Exception {
  final OaCredentialsErrorType type;
  final String message;

  const OaCredentialsException({
    required this.type,
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}

class LoginCaptchaCancelledException implements Exception {
  const LoginCaptchaCancelledException();
}

/// 操作之前需要先登录
class NeedLoginException implements Exception {
  final String msg;
  final String url;

  const NeedLoginException({this.msg = '目标操作需要登录', this.url = ''});

  @override
  String toString() {
    return msg;
  }
}

/// 未知的验证错误
class UnknownAuthException implements Exception {
  final String msg;

  const UnknownAuthException({this.msg = '未知验证错误'});

  @override
  String toString() {
    return msg;
  }
}

/// 超过最大重试次数
class MaxRetryExceedException implements Exception {
  final String msg;

  const MaxRetryExceedException({this.msg = '未知验证错误'});

  @override
  String toString() {
    return msg;
  }
}
