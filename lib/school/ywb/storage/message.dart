import 'package:hive/hive.dart';

import '../entity/application.dart';

class ApplicationMessageStorage {
  final Box<dynamic> box;

  const ApplicationMessageStorage(this.box);
}
