import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/life/electricity/storage/electricity.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

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
  late final StreamSubscription<LifePageRefreshEvent> $refreshEvent;

  @override
  initState() {
    super.initState();
    onRoomBalanceChanged.addListener(updateRoomAndBalance);
    $refreshEvent = lifeEventBus.on<LifePageRefreshEvent>().listen((event) {
      refresh(active: true);
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
    final selectedRoom = ElectricityBalanceInit.storage.selectedRoom;
    if (selectedRoom == null) return;
    try {
      ElectricityBalanceInit.storage.lastBalance = await ElectricityBalanceInit.service.getBalance(selectedRoom);
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(i18n.refreshFailedTip.text());
      }
      return;
    }
    if (active) {
      if (!mounted) return;
      context.showSnackBar(i18n.refreshSuccessTip.text());
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoom = ElectricityBalanceInit.storage.selectedRoom;
    final balance = ElectricityBalanceInit.storage.lastBalance;
    return AppCard(
      view: selectedRoom != null && balance != null
          ? buildBalanceCard(
              balance: balance,
              selectedRoom: selectedRoom,
            )
          : const SizedBox(),
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
        if (balance != null && selectedRoom != null && !isCupertino)
          IconButton(
            onPressed: () async {
              await shareBalance(balance: balance, selectedRoom: selectedRoom, context: context);
            },
            icon: const Icon(Icons.share_outlined),
          ),
        IconButton(
          onPressed: selectedRoom == null
              ? null
              : () async {
                  ElectricityBalanceInit.storage.selectedRoom = null;
                },
          icon: const Icon(Icons.delete_outlined),
        ),
      ],
    );
  }

  Widget buildBalanceCard({
    required ElectricityBalance balance,
    required String selectedRoom,
  }) {
    if (!isCupertino) {
      return ElectricityBalanceCard(
        balance: balance,
      ).sized(h: 120);
    }
    return Builder(
      builder: (ctx) => CupertinoContextMenu.builder(
        actions: [
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.share,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await shareBalance(balance: balance, selectedRoom: selectedRoom, context: ctx);
            },
            child: i18n.share.text(),
          ),
        ],
        builder: (ctx, animation) => ElectricityBalanceCard(
          balance: balance,
        ).sized(h: 120),
      ),
    );
  }
}

Future<void> shareBalance({
  required ElectricityBalance balance,
  required String selectedRoom,
  required BuildContext context,
}) async {
  final text = "#$selectedRoom: ${balance.l10nBalance()}, ${balance.l10nPower()}";
  final box = context.findRenderObject() as RenderBox?;
  final sharePositionOrigin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
    assert(sharePositionOrigin != null, "sharePositionOrigin should be nonnull on iPad and macOS");
  }
  await Share.share(
    text,
    sharePositionOrigin: sharePositionOrigin,
  );
}
