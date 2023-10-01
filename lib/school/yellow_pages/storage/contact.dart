import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/contact.dart';

class _K {
  static const history = "/interactHistory";
}

class YellowPagesStorage {
  final Box box;
  final int maxHistoryLength;

  const YellowPagesStorage(
    this.box, {
    this.maxHistoryLength = 5,
  });

  List<SchoolContact>? get interactHistory => (box.get(_K.history) as List?)?.cast<SchoolContact>();

  set interactHistory(List<SchoolContact>? newV) {
    if (newV != null) {
      newV = newV.sublist(0, min(newV.length, maxHistoryLength));
    }
    box.put(_K.history, newV);
  }

  ValueListenable<Box> listenHistory() => box.listenable(keys: [_K.history]);
}

extension YellowPagesStorageX on YellowPagesStorage {
  void addInteractHistory(SchoolContact contact) {
    final interactHistory = this.interactHistory ?? <SchoolContact>[];
    if (interactHistory.any((e) => e == contact)) return;
    interactHistory.insert(0, contact);
    this.interactHistory = interactHistory;
  }
}
