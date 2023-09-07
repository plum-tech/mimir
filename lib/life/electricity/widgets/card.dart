import 'package:flutter/material.dart';
import '../entity/balance.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';

class ElectricityBalanceCard extends StatelessWidget {
  final ElectricityBalance? balance;
  final double? elevation;

  const ElectricityBalanceCard({
    super.key,
    required this.balance,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return [
      buildInfoRow(context, Icons.offline_bolt, i18n.remainingPower, balance.powerText),
      buildInfoRow(context, Icons.savings, i18n.balance, balance.balanceText, color: balance.balanceColor),
    ].column(maa: MainAxisAlignment.spaceEvenly).inCard(elevation: elevation);
  }

  Widget buildInfoRow(BuildContext context, IconData icon, String title, String? content, {Color? color}) {
    final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color);
    return ListTile(
      leading: Icon(icon),
      titleTextStyle: style,
      title: Text(title, overflow: TextOverflow.fade),
      trailing: content == null
          ? const LimitedBox(maxWidth: 10, maxHeight: 10, child: CircularProgressIndicator())
          : content.text(style: style, overflow: TextOverflow.fade),
    );
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
