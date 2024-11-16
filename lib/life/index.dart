import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/life/electricity/card.dart';
import 'package:mimir/life/expense_records/card.dart';
import 'package:rettulf/rettulf.dart';

import 'event.dart';
import "i18n.dart";

class LifePage extends ConsumerStatefulWidget {
  const LifePage({super.key});

  @override
  ConsumerState<LifePage> createState() => _LifePageState();
}

class _LifePageState extends ConsumerState<LifePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                snap: true,
                title: i18n.navigation.text(),
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: RefreshIndicator.adaptive(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            debugPrint("Life page refreshed");
            await HapticFeedback.heavyImpact();
            await lifeEventBus.notifyListeners();
          },
          child: CustomScrollView(
            slivers: [
              SliverList.list(children: const [
                ExpenseRecordsAppCard(),
                ElectricityBalanceAppCard(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
