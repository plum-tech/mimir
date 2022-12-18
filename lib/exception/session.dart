// TODO: I18n msg?
/// 认证失败
class CredentialsInvalidException implements Exception {
  final String msg;

  const CredentialsInvalidException({this.msg = ''});

  @override
  String toString() {
    return msg;
  }
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
