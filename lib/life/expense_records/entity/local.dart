import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:unicons/unicons.dart';

import 'remote.dart';

part 'local.g.dart';

@HiveType(typeId: HiveTypeId.expenseTransaction)
class Transaction {
  /// The compound of [TransactionRaw.date] and [TransactionRaw.time].
  @HiveField(0)
  final DateTime datetime;

  /// [TransactionRaw.customerId]
  @HiveField(1)
  final int consumerId;

  @HiveField(2)
  final TransactionType type;
  @HiveField(3)
  final double balanceBefore;
  @HiveField(4)
  final double balanceAfter;

  /// It's absolute
  @HiveField(5)
  final double deltaAmount;
  @HiveField(6)
  final String deviceName;
  @HiveField(7)
  final String note;

  const Transaction({
    required this.datetime,
    required this.consumerId,
    required this.type,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.deltaAmount,
    required this.deviceName,
    required this.note,
  });

  Transaction copyWith({
    DateTime? datetime,
    int? consumerId,
    TransactionType? type,
    double? balanceBefore,
    double? balanceAfter,
    double? deltaAmount,
    String? deviceName,
    String? note,
  }) {
    return Transaction(
      datetime: datetime ?? this.datetime,
      consumerId: consumerId ?? this.consumerId,
      type: type ?? this.type,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      deltaAmount: deltaAmount ?? this.deltaAmount,
      deviceName: deviceName ?? this.deviceName,
      note: note ?? this.note,
    );
  }
}

final _textInBrackets = RegExp(r'\([^)]*\)');

extension TransactionX on Transaction {
  bool get isConsume => (balanceAfter - balanceBefore) < 0;

  String? get bestTitle {
    if (deviceName.isNotEmpty) {
      return deviceName;
    } else if (note.isNotEmpty) {
      return note;
    } else {
      return null;
    }
  }

  String shortDeviceName() {
    return deviceName.replaceAll(_textInBrackets, '');
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

@HiveType(typeId: HiveTypeId.expenseTransactionType)
enum TransactionType {
  @HiveField(0)
  water((UniconsLine.water_glass, Color(0xff8acde1))),
  @HiveField(1)
  shower((Icons.shower_outlined, Color(0xFF2196F3))),
  @HiveField(2)
  food((Icons.restaurant, Color(0xffe78d32))),
  @HiveField(3)
  store((Icons.store_outlined, Color(0xFF0DAB30))),
  @HiveField(4)
  topUp((Icons.savings, Colors.blue)),
  @HiveField(5)
  subsidy((Icons.handshake_outlined, Color(0xffdd2e22))),
  @HiveField(6)
  coffee((Icons.coffee_rounded, Color(0xFF6F4E37))),
  @HiveField(7)
  library((Icons.import_contacts_outlined, Color(0xffa75f1d))),
  @HiveField(8)
  other((Icons.menu_rounded, Colors.grey));

  final (IconData icon, Color) style;

  IconData get icon => style.$1;

  Color get color => style.$2;

  const TransactionType(this.style);

  String localized() => "expenseRecords.type.$name".tr();
}
