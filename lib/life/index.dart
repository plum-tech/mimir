import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/life/electricity/card.dart';
import 'package:sit/life/expense_records/card.dart';
import 'package:sit/life/lab_door/card.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
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
    final loginStatus = ref.watch(CredentialsInit.storage.$oaLoginStatus);
    final campus = ref.watch(Settings.$campus) ?? Campus.fengxian;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
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
              SliverList.list(children: [
                if (loginStatus != LoginStatus.never) const ExpenseRecordsAppCard(),
                if (campus.capability.enableElectricity) const ElectricityBalanceAppCard(),
                if (ref.watch(Dev.$on)) const OpenLabDoorAppCard(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
