import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/life/electricity/storage/electricity.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';
import 'init.dart';
import 'widget/card.dart';
import 'widget/search.dart';

class ElectricityBalanceAppCard extends StatefulWidget {
  const ElectricityBalanceAppCard({super.key});

  @override
  State<ElectricityBalanceAppCard> createState() => _ElectricityBalanceAppCardState();
}

class _ElectricityBalanceAppCardState extends State<ElectricityBalanceAppCard> {
  final onRoomBalanceChanged = ElectricityBalanceInit.storage.onRoomBalanceChanged;

  @override
  initState() {
    super.initState();
    onRoomBalanceChanged.addListener(updateRoomAndBalance);
    refresh(active: false);
  }

  @override
  dispose() {
    onRoomBalanceChanged.removeListener(updateRoomAndBalance);
    super.dispose();
  }

  void updateRoomAndBalance() {
    setState(() {});
  }

  /// The electricity balance is refreshed approximately every 15 minutes.
  Future<void> refresh({required bool active}) async {
    final selectedRoom = ElectricityBalanceInit.storage.selectedRoom;
    if (selectedRoom == null) return;
    try {
      ElectricityBalanceInit.storage.lastBalance = await ElectricityBalanceInit.service.getBalance(selectedRoom);
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(i18n.updateFailedTip.text());
      }
      return;
    }
    if (active) {
      if (!mounted) return;
      context.showSnackBar(i18n.updateSuccessTip.text());
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
    final selectedRoom = ElectricityBalanceInit.storage.selectedRoom;
    final balance = ElectricityBalanceInit.storage.lastBalance;
    return AppCard(
      view: selectedRoom == null
          ? const SizedBox()
          : ElectricityBalanceCard(
              balance: balance,
            ).sized(h: 120),
      title: i18n.title.text(),
      subtitle: selectedRoom == null ? null : "#$selectedRoom".text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            final room = await searchRoom(
              ctx: context,
              searchHistory: ElectricityBalanceInit.storage.searchHistory ?? const <String>[],
              roomList: R.roomList,
            );
            if (room == null) return;
            if (ElectricityBalanceInit.storage.selectedRoom != room) {
              ElectricityBalanceInit.storage.selectNewRoom(room);
              await refresh(active: true);
            }
          },
          label: i18n.search.text(),
          icon: const Icon(Icons.search),
        ),
      ],
      rightActions: [
        IconButton(
          onPressed: selectedRoom == null
              ? null
              : () async {
                  ElectricityBalanceInit.storage.selectedRoom = null;
                },
          icon: const Icon(Icons.delete_outlined),
        ),
        IconButton(
          onPressed: selectedRoom == null
              ? null
              : () async {
                  await refresh(active: true);
                },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
