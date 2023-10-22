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
    final powerText = balance?.l10nPower();
    final balanceText = balance?.l10nBalance();
    final balanceColor =
        warningBalance == null || balance == null || warningBalance < balance.balance ? null : warningColor;
    return [
      ListTile(
        leading: const Icon(Icons.offline_bolt),
        titleTextStyle: context.textTheme.titleMedium,
        title: i18n.remainingPower.text(),
        trailing: powerText == null
            ? const CircularProgressIndicator.adaptive()
            : powerText.text(style: context.textTheme.titleMedium),
      ),
      ListTile(
        leading: Icon(Icons.savings, color: balanceColor),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(color: balanceColor),
        title: i18n.balance.text(),
        trailing: balanceText == null
            ? const CircularProgressIndicator.adaptive()
            : balanceText.text(style: context.textTheme.titleMedium?.copyWith(color: balanceColor)),
      ),
    ].column(maa: MainAxisAlignment.spaceEvenly).inCard();
  }
}

extension ElectricityBalanceX on ElectricityBalance {
  String l10nPower() => i18n.unit.powerKwh(remainingPower.toStringAsFixed(2));

  String l10nBalance() => i18n.unit.rmb(balance.toStringAsFixed(2));
}
