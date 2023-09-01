import '../dao/message.dart';
import '../entity/message.dart';
import '../storage/message.dart';

class ApplicationMessageCache implements ApplicationMessageDao {
  final ApplicationMessageDao from;
  final ApplicationMessageStorage to;
  Duration expiration;

  ApplicationMessageCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<ApplicationMsgCount?> getMessageCount() async {
    if (to.box.msgCount.needRefresh(after: expiration)) {
      try {
        final res = await from.getMessageCount();
        to.setMessageCount(res);
        return res;
      } catch (e) {
        return to.getMessageCount();
      }
    } else {
      return to.getMessageCount();
    }
  }

  @override
  Future<ApplicationMsgPage?> getAllMessage() async {
    if (to.box.allMessages.needRefresh(after: expiration)) {
      try {
        final res = await from.getAllMessage();
        to.setAllMessage(res);
        return res;
      } catch (e) {
        return to.getAllMessage();
      }
    } else {
      return to.getAllMessage();
    }
  }
}
