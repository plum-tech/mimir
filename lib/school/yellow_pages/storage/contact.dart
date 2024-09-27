import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/utils/json.dart';

import '../entity/contact.dart';

class _K {
  static const history = "/interactHistory";
}

class YellowPagesStorage {
  Box get box => HiveInit.yellowPages;
  final int maxHistoryLength;

  YellowPagesStorage({
    this.maxHistoryLength = 2,
  });

  List<SchoolContact>? get interactHistory =>
      decodeJsonList(box.safeGet<String>(_K.history), (obj) => SchoolContact.fromJson(obj));

  set interactHistory(List<SchoolContact>? newV) {
    if (newV != null) {
      newV = newV.sublist(0, min(newV.length, maxHistoryLength));
    }
    box.safePut<String>(_K.history, encodeJsonList(newV));
  }

  late final $interactHistory = box.provider(
    _K.history,
    get: () => interactHistory,
    set: (newV) => interactHistory = newV,
  );
}

extension YellowPagesStorageX on YellowPagesStorage {
  void addInteractHistory(SchoolContact contact) {
    final interactHistory = this.interactHistory ?? <SchoolContact>[];
    if (interactHistory.any((e) => e == contact)) return;
    interactHistory.insert(0, contact);
    this.interactHistory = interactHistory;
  }
}
