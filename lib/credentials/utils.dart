import 'package:sit/credentials/entity/user_type.dart';

/// 本、专科生（10位学号）
final RegExp _reUndergraduateId = RegExp(r'^(\d{6}[YGHE\d]\d{3})$');

/// 研究生（9位学号）
final RegExp _rePostgraduateId = RegExp(r'^(\d{2}6\d{6})$');

/// 教师（4位工号）
final RegExp _reTeacherId = RegExp(r'^(\d{4})$');

/// [oaAccount] can be a student ID or a work number.
OaUserType? estimateOaUserType(String oaAccount) {
  if (oaAccount.length == 10 && _reUndergraduateId.hasMatch(oaAccount.toUpperCase())) {
    return OaUserType.undergraduate;
  } else if (oaAccount.length == 9 && _rePostgraduateId.hasMatch(oaAccount)) {
    return OaUserType.postgraduate;
  } else if (oaAccount.length == 4 && _reTeacherId.hasMatch(oaAccount)) {
    return OaUserType.other;
  }
  return null;
}
