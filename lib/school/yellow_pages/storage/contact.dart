import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/contact.dart';

class _K {
  static const history = "/history";
}

class YellowPagesStorage {
  final Box<dynamic> box;

  const YellowPagesStorage(this.box);

  List<SchoolContact>? get history => box.get(_K.history);

  set history(List<SchoolContact>? newV) => box.put(_K.history, newV);

  ValueListenable<Box<dynamic>> get $history => box.listenable(keys: [_K.history]);
}
