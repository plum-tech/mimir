import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/life/electricity/storage/electricity.dart';
import 'package:sit/r.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_context_menu/super_context_menu.dart';

import '../event.dart';
import 'entity/balance.dart';
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
  final onRoomBalanceChanged = ElectricityBalanceInit.storage.listenRoomBalanceChange();
  late final EventSubscription $refreshEvent;

  @override
  initState() {
    super.initState();
    onRoomBalanceChanged.addListener(updateRoomAndBalance);
    $refreshEvent = lifeEventBus.addListener(() async {
      await refresh(active: true);
    });
    if (Settings.life.electricity.autoRefresh) {
      refresh(active: false);
    }
  }

  @override
  dispose() {
    onRoomBalanceChanged.removeListener(updateRoomAndBalance);
    $refreshEvent.cancel();
    super.dispose();
  }

  void updateRoomAndBalance() {
    setState(() {});
  }

  /// The electricity balance is refreshed approximately every 15 minutes.
  Future<void> refresh({required bool active}) async {
    final selectedRoom = Settings.life.electricity.selectedRoom;
    if (selectedRoom == null) return;
    try {
      final lastBalance = await ElectricityBalanceInit.service.getBalance(selectedRoom);
      if (lastBalance.roomNumber == selectedRoom) {
        ElectricityBalanceInit.storage.lastBalance = lastBalance;
      }
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(content: i18n.refreshFailedTip.text());
      }
      return;
    }
    if (active) {
      if (!mounted) return;
      context.showSnackBar(content: i18n.refreshSuccessTip.text());
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoom = Settings.life.electricity.selectedRoom;
    final lastBalance = ElectricityBalanceInit.storage.lastBalance;
    final balance = lastBalance?.roomNumber == selectedRoom ? lastBalance : null;
    return AppCard(
      view: selectedRoom != null && balance != null
          ? buildBalanceCard(
              balance: balance,
              selectedRoom: selectedRoom,
            )
          : const SizedBox(),
      title: i18n.title.text(),
      subtitle: balance != null
          ? "#${balance.roomNumber}".text()
          : selectedRoom != null
              ? "#$selectedRoom".text()
              : null,
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            final $searchHistory = ValueNotifier(ElectricityBalanceInit.storage.searchHistory ?? const <String>[]);
            $searchHistory.addListener(() {
              ElectricityBalanceInit.storage.searchHistory = $searchHistory.value;
            });
            final room = await searchRoom(
              ctx: context,
              $searchHistory: $searchHistory,
              roomList: R.roomList,
            );
            $searchHistory.dispose();
            if (room == null) return;
            if (Settings.life.electricity.selectedRoom != room) {
              ElectricityBalanceInit.storage.selectNewRoom(room);
              await refresh(active: true);
            }
          },
          label: i18n.searchRoom.text(),
          icon: const Icon(Icons.search),
        ),
      ],
      rightActions: [
        if (balance != null && selectedRoom != null && !isCupertino)
          IconButton(
            tooltip: i18n.share,
            onPressed: () async {
              await shareBalance(balance: balance, selectedRoom: selectedRoom, context: context);
            },
            icon: const Icon(Icons.share_outlined),
          ),
      ],
    );
  }

  Widget buildBalanceCard({
    required ElectricityBalance balance,
    required String selectedRoom,
  }) {
    if (!supportContextMenu) {
      return Dismissible(
        direction: DismissDirection.endToStart,
        key: const ValueKey("Balance"),
        onDismissed: (dir) async {
          await HapticFeedback.heavyImpact();
          Settings.life.electricity.selectedRoom = null;
        },
        child: buildCard(balance),
      );
    }
    return Builder(
      builder: (ctx) => ContextMenuWidget(
        menuProvider: (MenuRequest request) {
          return Menu(
            children: [
              MenuAction(
                image: MenuImage.icon(CupertinoIcons.share),
                title: i18n.share,
                callback: () async {
                  await shareBalance(balance: balance, selectedRoom: selectedRoom, context: ctx);
                },
              ),
              MenuAction(
                image: MenuImage.icon(CupertinoIcons.delete),
                title: i18n.delete,
                attributes: const MenuActionAttributes(destructive: true),
                activator: const SingleActivator(LogicalKeyboardKey.delete),
                callback: () async {
                  await HapticFeedback.heavyImpact();
                  Settings.life.electricity.selectedRoom = null;
                },
              ),
            ],
          );
        },
        child: buildCard(balance),
      ),
    );
  }

  Widget buildCard(ElectricityBalance balance) {
    return ElectricityBalanceCard(
      balance: balance,
    ).sized(h: 120);
  }
}

Future<void> shareBalance({
  required ElectricityBalance balance,
  required String selectedRoom,
  required BuildContext context,
}) async {
  final text =
      "#$selectedRoom: ${i18n.unit.rmb(balance.balance.toStringAsFixed(2))}, ${i18n.unit.powerKwh(balance.remainingPower.toStringAsFixed(2))}";
  await Share.share(
    text,
    sharePositionOrigin: context.getSharePositionOrigin(),
  );
}
