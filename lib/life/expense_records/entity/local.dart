import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sit/storage/hive/type_id.dart';
import 'package:unicons/unicons.dart';

import 'remote.dart';

part 'local.g.dart';

@HiveType(typeId: CacheHiveType.expenseTransaction)
class Transaction {
  /// The compound of [TransactionRaw.date] and [TransactionRaw.time].
  @HiveField(0)
  final DateTime timestamp;

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
    required this.timestamp,
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
      timestamp: datetime ?? this.timestamp,
      consumerId: consumerId ?? this.consumerId,
      type: type ?? this.type,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      deltaAmount: deltaAmount ?? this.deltaAmount,
      deviceName: deviceName ?? this.deviceName,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return jsonEncode({
      "datetime": timestamp.toString(),
      "consumerId": consumerId,
      "type": type.toString(),
      "balanceBefore": balanceBefore,
      "balanceAfter": balanceAfter,
      "deltaAmount": deltaAmount,
      "deviceName": deviceName,
      "note": note,
    });
  }
}

final _textInBrackets = RegExp(r'\([^)]*\)');

extension TransactionX on Transaction {
  bool get isConsume =>
      (balanceAfter - balanceBefore) < 0 && type != TransactionType.topUp && type != TransactionType.subsidy;

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

@HiveType(typeId: CacheHiveType.expenseTransactionType)
enum TransactionType {
  @HiveField(0)
  water((UniconsLine.water_glass, Color(0xff8acde1)), isConsume: true),
  @HiveField(1)
  shower((Icons.shower_outlined, Color(0xFF2196F3)), isConsume: true),
  @HiveField(2)
  food((Icons.restaurant, Color(0xffe78d32)), isConsume: true),
  @HiveField(3)
  store((Icons.store_outlined, Color(0xFF0DAB30)), isConsume: true),
  @HiveField(4)
  topUp((Icons.savings, Colors.blue), isConsume: false),
  @HiveField(5)
  subsidy((Icons.handshake_outlined, Color(0xffdd2e22)), isConsume: false),
  @HiveField(6)
  coffee((Icons.coffee_rounded, Color(0xFF6F4E37)), isConsume: true),
  @HiveField(7)
  library((Icons.import_contacts_outlined, Color(0xffa75f1d)), isConsume: true),
  @HiveField(8)
  other((Icons.menu_rounded, Colors.grey), isConsume: true);

  final bool isConsume;
  final (IconData icon, Color) style;

  IconData get icon => style.$1;

  Color get color => style.$2;

  const TransactionType(
    this.style, {
    required this.isConsume,
  });

  String localized() => "expenseRecords.type.$name".tr();
}
