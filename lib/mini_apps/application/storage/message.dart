import 'package:hive/hive.dart';

import '../dao/message.dart';
import '../entity/message.dart';
import '../using.dart';

class ApplicationMessageStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final msgCount = Named<ApplicationMsgCount>("/messageCount");
  late final allMessages = Named<ApplicationMsgPage>("/messages");

  ApplicationMessageStorageBox(this.box);
}

class ApplicationMessageStorage extends ApplicationMessageDao {
  final ApplicationMessageStorageBox box;

  ApplicationMessageStorage(Box<dynamic> hive) : box = ApplicationMessageStorageBox(hive);

  @override
  Future<ApplicationMsgCount?> getMessageCount() async {
    return box.msgCount.value;
  }

  @override
  Future<ApplicationMsgPage?> getAllMessage() async {
    return box.allMessages.value;
  }

  void setMessageCount(ApplicationMsgCount? msgCount) {
    box.msgCount.value = msgCount;
  }

  void setAllMessage(ApplicationMsgPage? messages) {
    box.allMessages.value = messages;
  }
}
