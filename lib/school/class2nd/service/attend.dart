import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/class2nd.dart';

class Class2ndApplicationService {
  static const _codeMessage = [
    '检查成功',
    '您的个人信息不全，请补全您的信息！',
    '您已申请过该活动，不能重复申请！',
    '对不起，您今天的申请次数已达上限！',
    '对不起，该活动的申请人数已达上限！',
    '对不起，该活动已过期并停止申请！',
    '您已申请过该时间段的活动，不能重复申请！',
    '对不起，您不能申请该活动！',
    '对不起，您不在该活动的范围内！',
  ];

  Class2ndSession get session => Init.class2ndSession;

  const Class2ndApplicationService();

  /// 提交最后的活动申请
  Future<String> _sendFinalRequest(int activityId) async {
    final res = await session.request(
      'http://sc.sit.edu.cn/public/pcenter/applyActivity.action?activityId=$activityId',
      options: Options(
        method: "GET",
      ),
    );
    return res.data as String;
  }

  Future<String> _sendCheckRequest(int activityId) async {
    final res = await session.request(
      'http://sc.sit.edu.cn/public/pcenter/check.action?activityId=$activityId',
      options: Options(
        method: "GET",
      ),
    );
    final code = (res.data as String).trim();

    return _codeMessage[int.parse(code)];
  }

  /// 参加活动
  Future<String> join(
    int activityId, {
    bool force = false,
  }) async {
    if (!force) {
      final result = await _sendCheckRequest(activityId);
      if (result != '检查成功') {
        return result;
      }
    }
    final result = await _sendFinalRequest(activityId);
    return result.contains('申请成功') ? '申请成功' : '申请失败';
  }
}
