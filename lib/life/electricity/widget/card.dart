import 'package:flutter/material.dart';
import '../entity/balance.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';

class ElectricityBalanceCard extends StatelessWidget {
  final ElectricityBalance? balance;
  final double? warningBalance;
  final Color warningColor;

  const ElectricityBalanceCard({
    super.key,
    required this.balance,
    this.warningBalance = 10.0,
    this.warningColor = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    final warningBalance = this.warningBalance;
    final balance = this.balance;
    final powerText = balance.powerText;
    final balanceText = balance.balanceText;
    final balanceColor =
        warningBalance == null || balance == null || warningBalance < balance.balance ? null : warningColor;
    return [
      ListTile(
        leading: const Icon(Icons.offline_bolt),
        titleTextStyle: context.textTheme.titleMedium,
        title: i18n.remainingPower.text(),
        trailing: powerText == null
            ? const LimitedBox(maxWidth: 8, maxHeight: 8, child: CircularProgressIndicator())
            : powerText.text(style: context.textTheme.titleMedium),
      ),
      ListTile(
        leading: Icon(Icons.savings, color: balanceColor),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(color: balanceColor),
        title: i18n.balance.text(),
        trailing: balanceText == null
            ? const LimitedBox(maxWidth: 8, maxHeight: 8, child: CircularProgressIndicator())
            : balanceText.text(style: context.textTheme.titleMedium?.copyWith(color: balanceColor)),
      ),
    ].column(maa: MainAxisAlignment.spaceEvenly).inCard();
  }
}

extension BalanceEx on ElectricityBalance? {
  String? get powerText {
    final self = this;
    return self == null ? null : i18n.unit.powerKwh(self.remainingPower.toStringAsFixed(2));
  }

  String? get balanceText {
    final self = this;
    return self == null ? null : i18n.unit.rmb(self.balance.toStringAsFixed(2));
  }

  Color? get balanceColor {
    final self = this;
    if (self == null) {
      return null;
    } else {
      return self.balance < 10 ? Colors.red : null;
    }
  }
}
