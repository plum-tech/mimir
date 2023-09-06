import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/life/electricity/widgets/search.dart';
import 'package:mimir/main/network_tool/using.dart';
import 'package:mimir/mini_app.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';
import 'entity/balance.dart';
import 'init.dart';
import 'widgets/card.dart';

class ElectricityBalanceAppCard extends StatefulWidget {
  const ElectricityBalanceAppCard({super.key});

  @override
  State<ElectricityBalanceAppCard> createState() => _ElectricityBalanceAppCardState();
}

class _ElectricityBalanceAppCardState extends State<ElectricityBalanceAppCard> {
  ElectricityBalance? balance = ElectricityBalanceInit.storage.lastBalance;
  String? selectedRoom = ElectricityBalanceInit.storage.selectedRoom;
  late Timer refreshTimer;

  @override
  initState() {
    super.initState();
    ElectricityBalanceInit.storage.$selectedRoom.addListener(updateSelectedRoom);
    // auto refresh per minute.
    refreshTimer = runPeriodically(const Duration(minutes: 1), (timer) async {
      await _refresh();
    });
  }

  @override
  dispose() {
    ElectricityBalanceInit.storage.$selectedRoom.removeListener(updateSelectedRoom);
    refreshTimer.cancel();
    super.dispose();
  }

  void updateSelectedRoom() {
    if (!mounted) return;
    setState(() {
      selectedRoom = ElectricityBalanceInit.storage.selectedRoom;
    });
  }

  Future<void> _refresh({bool active = false}) async {
    final selectedRoom = this.selectedRoom;
    if (selectedRoom == null) return;
    final newBalance = await ElectricityBalanceInit.service.getBalance(selectedRoom);
    ElectricityBalanceInit.storage.lastBalance = newBalance;
    if (!mounted) return;
    setState(() {
      balance = newBalance;
    });
    if (active) {
      context.showSnackBar("Electricity balance refreshed successfully!".text());
    }
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
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: selectedRoom == null
              ? const SizedBox()
              : ElectricityBalanceCard(
                  balance: balance,
                ).sized(h: 120),
        ),
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: MiniApp.elecBill.l10nName().text(),
          subtitleTextStyle: context.textTheme.bodyLarge,
          subtitle: selectedRoom == null ? null : "#$selectedRoom".text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.icon(
                onPressed: () async {
                  final room = await searchRoom(
                    ctx: context,
                    searchHistory: ElectricityBalanceInit.storage.searchHistory ?? const [],
                    roomList: R.roomList,
                  );
                  if (room == null) return;
                  if (!mounted) return;
                  ElectricityBalanceInit.storage.selectedRoom = room;
                  await _refresh(active: true);
                },
                label: "Search".text(),
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: selectedRoom == null
                    ? null
                    : () async {
                        await _refresh(active: true);
                      },
                icon: Icon(Icons.refresh))
          ],
        ).padOnly(l: 5, b: 5),
      ].column(),
    );
  }
}
