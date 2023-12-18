import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sit/init.dart';

import 'package:sit/session/class2nd.dart';

enum Class2ndApplicationCheckResponse {
  successfulCheck,
  incompleteApplicantInfo,
  alreadyApplied,
  applicationReachLimitToday,
  activityReachParticipantLimit,
  activityExpired,
  applicantOccupiedWithinActivity,
  applicantNotPermitted,
  applicantNotIncluding,
  ;

  String l10n() => "class2nd.applicationResponse.$name".tr();

  const Class2ndApplicationCheckResponse();

  static Class2ndApplicationCheckResponse parse(String code) {
    const code2Response = {
      "0": successfulCheck,
      "1": incompleteApplicantInfo,
      "2": alreadyApplied,
      "3": applicationReachLimitToday,
      "4": activityReachParticipantLimit,
      "5": activityExpired,
      "6": applicantOccupiedWithinActivity,
      "7": applicantNotPermitted,
      "8": applicantNotIncluding,
    };
    return code2Response[code] ?? applicantNotPermitted;
  }
}

class Class2ndApplicationService {
  Class2ndSession get session => Init.class2ndSession;

  const Class2ndApplicationService();

  Future<Class2ndApplicationCheckResponse> check(int activityId) async {
    final res = await session.request(
      'http://sc.sit.edu.cn/public/pcenter/check.action?activityId=$activityId',
      options: Options(
        method: "GET",
      ),
    );
    final code = (res.data as String).trim();
    return Class2ndApplicationCheckResponse.parse(code);
  }

  /// 提交最后的活动申请
  Future<bool> apply(int activityId) async {
    final res = await session.request(
      'http://sc.sit.edu.cn/public/pcenter/applyActivity.action?activityId=$activityId',
      options: Options(
        method: "GET",
      ),
    );
    final code = res.data as String;
    return code.contains('申请成功');
  }
}
