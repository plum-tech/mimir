import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/timer.dart';
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
  late Timer refreshTimer;

  @override
  initState() {
    super.initState();
    ElectricityBalanceInit.storage.onRoomBalanceChanged.addListener(updateRoomAndBalance);
    // auto refresh per minute.
    refreshTimer = runPeriodically(const Duration(minutes: 5), (timer) async {
      await _refresh();
    });
  }

  @override
  dispose() {
    ElectricityBalanceInit.storage.onRoomBalanceChanged.removeListener(updateRoomAndBalance);
    refreshTimer.cancel();
    super.dispose();
  }

  void updateRoomAndBalance() {
    setState(() {});
  }

  Future<void> _refresh({bool active = false}) async {
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
          title: i18n.title.text(),
          subtitleTextStyle: context.textTheme.bodyLarge,
          subtitle: selectedRoom == null ? null : "#$selectedRoom".text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.icon(
              onPressed: () async {
                final history = ElectricityBalanceInit.storage.searchHistory ?? {};
                final searchResult = await searchRoom(
                  ctx: context,
                  searchHistory: history.toList(),
                  roomList: R.roomList,
                );
                if (searchResult == null) return;
                final (:room, :isClear) = searchResult;
                final old = ElectricityBalanceInit.storage.selectedRoom;
                if (isClear) {
                  if (old != null) {
                    ElectricityBalanceInit.storage.selectedRoom = null;
                  }
                } else {
                  if (old != room) {
                    ElectricityBalanceInit.storage.selectedRoom = room;
                    history.add(room);
                    ElectricityBalanceInit.storage.searchHistory = history;
                    await _refresh(active: true);
                  }
                }
              },
              label: i18n.search.text(),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: selectedRoom == null
                  ? null
                  : () async {
                      await _refresh(active: true);
                    },
              icon: const Icon(Icons.refresh),
            )
          ],
        ).padOnly(l: 16, b: 8, r: 16),
      ].column(),
    );
  }
}
