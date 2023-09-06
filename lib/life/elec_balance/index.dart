import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/life/elec_balance/init.dart';
import 'package:mimir/life/elec_balance/widgets/card.dart';
import 'package:mimir/main/network_tool/using.dart';
import 'package:mimir/mini_app.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';
import 'entity/balance.dart';

class ElectricityBalanceAppCard extends StatefulWidget {
  const ElectricityBalanceAppCard({super.key});

  @override
  State<ElectricityBalanceAppCard> createState() => _ElectricityBalanceAppCardState();
}

class _ElectricityBalanceAppCardState extends State<ElectricityBalanceAppCard> {
  ElectricityBalance? balance;
  late Timer refreshTimer;

  @override
  initState() {
    super.initState();
    // auto refresh per minute.
    refreshTimer = runPeriodically(const Duration(minutes : 1), (timer) async {
      await _refresh();
    });
  }

  @override
  dispose(){
    refreshTimer.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    final selectedRoom = "105604";
    setState(() {
      balance = null;
    });
    final newBalance = await ElectricityBalanceInit.service.getBalance(selectedRoom);
    if (!mounted) return;
    setState(() {
      balance = newBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: context.colorScheme.brightness,
        ),
      ),
      child: buildBody(),
    );
  }

  Widget buildBody() {
    return FilledCard(
      child: [
        SizedBox(
          height: 120,
          child: ElectricityBalanceCard(
            balance: balance,
          ),
        ),
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: MiniApp.elecBill.l10nName().text(),
          subtitleTextStyle: context.textTheme.bodyLarge,
          subtitle: "105604".text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.icon(onPressed: () {}, label: "Search".text(), icon: Icon(Icons.search)),
            IconButton(onPressed: _refresh, icon: Icon(Icons.refresh))
          ],
        ).padOnly(l: 5, b: 5),
      ].column(),
    );
  }
}
