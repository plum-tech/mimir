import 'package:hive/hive.dart';

import '../dao/message.dart';
import '../entity/message.dart';
import '../using.dart';

class ApplicationMessageStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final msgCount = named<ApplicationMessageCount>("/messageCount");
  late final allMessages = named<ApplicationMessagePage>("/messages");

  ApplicationMessageStorageBox(this.box);
}

class ApplicationMessageStorage extends ApplicationMessageDao {
  final ApplicationMessageStorageBox box;

  ApplicationMessageStorage(Box<dynamic> hive) : box = ApplicationMessageStorageBox(hive);

  @override
  Future<ApplicationMessageCount?> getMessageCount() async {
    return box.msgCount.value;
  }

  @override
  Future<ApplicationMessagePage?> getAllMessage() async {
    return box.allMessages.value;
  }

  void setMessageCount(ApplicationMessageCount? msgCount) {
    box.msgCount.value = msgCount;
  }

  void setAllMessage(ApplicationMessagePage? messages) {
    box.allMessages.value = messages;
  }
}
