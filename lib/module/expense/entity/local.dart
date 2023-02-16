import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:unicons/unicons.dart';

import './remote.dart';
import '../using.dart';
import 'shared.dart';

part 'local.g.dart';

const abosute = Object();

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
  @abosute
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

typedef _I = IconPair;

enum TransactionType {
  water(_I(UniconsLine.water_glass, Color(0xff8acde1))),
  shower(_I(Icons.shower_outlined, Color(0xFF2196F3))),
  food(_I(Icons.restaurant, Color(0xffe78d32))),
  store(_I(Icons.store_outlined, Color(0xFF0DAB30))),
  topUp(_I(Icons.savings, Colors.blue)),
  subsidy(_I(Icons.handshake_outlined, Color(0xffdd2e22))),
  coffee(_I(Icons.coffee_rounded, Color(0xFF6F4E37))),
  library(_I(Icons.import_contacts_outlined, Color(0xffa75f1d))),
  other(_I(Icons.menu_rounded, Colors.grey));

  final IconPair style;

  IconData get icon => style.icon;

  Color get color => style.color;

  const TransactionType(this.style);

  String localized() => "expense.type.$name";
}
