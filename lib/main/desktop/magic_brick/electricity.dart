import 'package:flutter/material.dart';
import 'package:mimir/mini_app.dart';
import 'package:mimir/mini_apps/symbol.dart';
import 'package:mimir/route.dart';
import 'package:mimir/storage/init.dart';

import '../widgets/brick.dart';
import 'package:mimir/mini_apps/elec_bill/i18n.dart';

class ElectricityBillBrick extends StatefulWidget {
  final String route;
  final IconBuilder icon;

  const ElectricityBillBrick({
    super.key,
    required this.route,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() => _ElectricityBillBrickState();
}

class _ElectricityBillBrickState extends State<ElectricityBillBrick> {
  final Balance? lastBalance = Kv.home.lastBalance;
  String? content;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final b = lastBalance;
    if (b != null) {
      content = i18n.lastBalance(b.roomNumber, b.balance.toStringAsPrecision(2));
    }
    return Brick(
      route: widget.route,
      icon: widget.icon,
      title: MiniApp.elecBill.l10nName(),
      subtitle: content ?? MiniApp.elecBill.l10nDesc(),
    );
  }
}
