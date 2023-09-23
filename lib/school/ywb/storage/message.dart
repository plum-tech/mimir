import 'package:hive/hive.dart';

import '../entity/message.dart';

class ApplicationMessageStorage {
  final Box<dynamic> box;

  const ApplicationMessageStorage(this.box);
}
