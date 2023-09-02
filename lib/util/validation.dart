import 'package:mimir/mini_apps/login/i18n.dart';

/// 本、专科生（10位学号）
final RegExp _reUndergraduateId = RegExp(r'^(\d{6}[YGHE\d]\d{3})$');

/// 研究生（9位学号）
final RegExp _rePostgraduateId = RegExp(r'^(\d{2}6\d{6})$');

/// 教师（4位工号）
final RegExp _reTeacherId = RegExp(r'^(\d{4})$');

/// [oaAccount] can be a student ID or a work number.
bool guessUserTypeByAccount(String oaAccount) {
  if (oaAccount.length == 10 && _reUndergraduateId.hasMatch(oaAccount.toUpperCase())) {
    return true;
  } else if (oaAccount.length == 9 && _rePostgraduateId.hasMatch(oaAccount)) {
    return true;
  } else if (oaAccount.length == 4 && _reTeacherId.hasMatch(oaAccount)) {
    return true;
  }
  return false;
}

// Only allow student ID/ work number.
String? studentIdValidator(String? account) {
  if (account != null && account.isNotEmpty) {
    if (!guessUserTypeByAccount(account)) {
      return const LoginI18n().invalidAccountFormat;
    }
  }
  return null;
}

/// 代理配置的正则匹配式. 格式为 (域名|IP):端口
/// 注意此处端口没有限制为 0-65535.
final RegExp reProxyString = RegExp(
    r'(([a-zA-Z0-9][-a-zA-Z0-9]{0,62}(.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+.?)|(((25[0-5])|(2[0-4]d)|(1dd)|([1-9]d)|d)(.((25[0-5])|(2[0-4]d)|(1dd)|([1-9]d)|d)){3})):\d{1,5}');

String? proxyValidator(String? proxy) {
  if (proxy != null && proxy.isNotEmpty) {
    if (!reProxyString.hasMatch(proxy)) {
      return '代理地址格式不正确';
    }
  }
  return null;
}
