import 'package:mimir/school/ywb/service/message.dart';

import '../entity/message.dart';
import '../storage/message.dart';

class ApplicationMessageCache {
  final ApplicationMessageService from;
  final ApplicationMessageStorage to;
  Duration expiration;

  ApplicationMessageCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  Future<ApplicationMessageCount?> getMessageCount({
    required String oaAccount,
  }) async {
    if (to.box.msgCount.needRefresh(after: expiration)) {
      try {
        final res = await from.getMessageCount(oaAccount: oaAccount);
        to.messageCount = res;
        return res;
      } catch (e) {
        return to.messageCount;
      }
    } else {
      return to.messageCount;
    }
  }

  Future<ApplicationMessagePage?> getAllMessage() async {
    if (to.box.allMessages.needRefresh(after: expiration)) {
      try {
        final res = await from.getAllMessage();
        to.allMessage = res;
        return res;
      } catch (e) {
        return to.allMessage;
      }
    } else {
      return to.allMessage;
    }
  }
}
