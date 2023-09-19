import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/message.dart';

class ApplicationMessageStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final msgCount = named<ApplicationMessageCount>("/messageCount");
  late final allMessages = named<ApplicationMessagePage>("/messages");

  ApplicationMessageStorageBox(this.box);
}

class ApplicationMessageStorage {
  final ApplicationMessageStorageBox box;

  ApplicationMessageStorage(Box<dynamic> hive) : box = ApplicationMessageStorageBox(hive);

  ApplicationMessageCount? get messageCount => box.msgCount.value;

  set messageCount(ApplicationMessageCount? newV) => box.msgCount.value = newV;

  ApplicationMessagePage? get allMessage => box.allMessages.value;

  set allMessage(ApplicationMessagePage? newV) => box.allMessages.value = newV;
}
