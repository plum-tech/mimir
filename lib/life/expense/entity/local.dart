import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:unicons/unicons.dart';

import 'remote.dart';
import 'shared.dart';

part 'local.g.dart';

@JsonSerializable()
class Transaction {
  Transaction();

  /// The compound of [TransactionRaw.transdate] and [TransactionRaw.transtime].
  DateTime datetime = defaultDateTime;

  /// [TransactionRaw.custid]
  int consumerId = 0;
  TransactionType type = TransactionType.other;
  double balanceBefore = 0;
  double balanceAfter = 0;

  /// It's absolute
  double deltaAmount = 0;

  String deviceName = "";
  String note = "";

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  String toString() => toJson().toString();
}

extension TransactionEnchanced on Transaction {
  bool get isConsume => (balanceAfter - balanceBefore) < 0;

  String? get bestTitle {
    if (deviceName.isNotEmpty) {
      return _stylizeTitle(deviceName);
    } else if (note.isNotEmpty) {
      return _stylizeTitle(note);
    } else {
      return null;
    }
  }

  String _stylizeTitle(String title) {
    return title.replaceAll("（", "(").replaceAll("）", ")");
  }

  Color get billColor => isConsume ? Colors.redAccent : Colors.green;

  String toReadableString() {
    if (deltaAmount == 0) {
      return deltaAmount.toStringAsFixed(2);
    } else {
      return "${isConsume ? '-' : '+'}${deltaAmount.toStringAsFixed(2)}";
    }
  }
}

enum TransactionType {
  water((UniconsLine.water_glass, Color(0xff8acde1))),
  shower((Icons.shower_outlined, Color(0xFF2196F3))),
  food((Icons.restaurant, Color(0xffe78d32))),
  store((Icons.store_outlined, Color(0xFF0DAB30))),
  topUp((Icons.savings, Colors.blue)),
  subsidy((Icons.handshake_outlined, Color(0xffdd2e22))),
  coffee((Icons.coffee_rounded, Color(0xFF6F4E37))),
  library((Icons.import_contacts_outlined, Color(0xffa75f1d))),
  other((Icons.menu_rounded, Colors.grey));

  final (IconData icon, Color) style;

  IconData get icon => style.$1;

  Color get color => style.$2;

  const TransactionType(this.style);

  String localized() => "expense.type.$name".tr();
}
