import '../entity/application.dart';
import 'application.dart';

class DemoYwbApplicationService implements YwbApplicationService {
  const DemoYwbApplicationService();

  @override
  Future<List<YwbApplication>> getApplicationsOf(
    YwbApplicationType type, {
    void Function(double progress)? onProgress,
  }) async {
    onProgress?.call(1);
    final now = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 1400));
    return [
      YwbApplication(
        workId: 9999,
        functionId: 'SIT-Life',
        name: '小应生活账号注册申请',
        note: '成功',
        startTs: now,
        track: [
          YwbApplicationTrack(
            actionType: 1,
            action: '发送',
            senderId: 'SITLife001',
            senderName: '用户',
            receiverId: 'SITLife000',
            receiverName: '小应生活',
            message: '申请注册',
            timestamp: now,
            step: '发送注册申请',
          ),
          YwbApplicationTrack(
            actionType: 1,
            action: '注册',
            senderId: 'SITLife000',
            senderName: '小应生活',
            receiverId: 'SITLife001',
            receiverName: '用户',
            message: '注册成功',
            timestamp: now.copyWith(minute: now.minute + 1),
            step: '返回注册申请状态',
          ),
        ],
      ),
    ];
  }
}
