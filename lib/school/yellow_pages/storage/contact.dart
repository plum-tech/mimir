import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/contact.dart';

class _K {
  static const history = "/history";
}

class YellowPagesStorage {
  final Box<dynamic> box;
  final int maxHistoryLength;

  const YellowPagesStorage(
    this.box, {
    this.maxHistoryLength = 5,
  });

  List<SchoolContact>? get history => box.get(_K.history);

  set history(List<SchoolContact>? newV) => box.put(_K.history, newV);

  ValueListenable<Box<dynamic>> get $history => box.listenable(keys: [_K.history]);
}

extension YellowPagesStorageX on YellowPagesStorage {
  void addHistory(SchoolContact contact) {
    final history = this.history ?? [];
    if (history.any((e) => e.phone == contact.phone)) return;
    history.insert(0, contact);
    history.length = min(history.length, maxHistoryLength);
    this.history = history;
  }
}
