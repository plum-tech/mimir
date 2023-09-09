import 'package:mimir/network/session.dart';

class ScJoinActivityService {
  static const _applyCheck = 'http://sc.sit.edu.cn/public/pcenter/check.action?activityId=';
  static const _applyRequest = 'http://sc.sit.edu.cn/public/pcenter/applyActivity.action?activityId=';

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

  final ISession session;

  const ScJoinActivityService(this.session);

  /// 提交最后的活动申请
  Future<String> _sendFinalRequest(int activityId) async {
    final url = _applyRequest + activityId.toString();
    return (await session.request(url, ReqMethod.get)).data;
  }

  Future<String> _sendCheckRequest(int activityId) async {
    final url = _applyCheck + activityId.toString();
    final code = ((await session.request(url, ReqMethod.get)).data as String).trim();

    return _codeMessage[int.parse(code)];
  }

  /// 参加活动
  Future<String> join(int activityId, [bool force = false]) async {
    if (!force) {
      final result = await _sendCheckRequest(activityId);
      if (result != '检查成功') {
        return result;
      }
    }
    return (await _sendFinalRequest(activityId)).contains('申请成功') ? '申请成功' : '申请失败';
  }
}
