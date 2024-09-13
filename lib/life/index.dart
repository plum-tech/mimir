import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/forum/card.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/feature/utils.dart';
import 'package:mimir/life/electricity/card.dart';
import 'package:mimir/life/expense_records/card.dart';
import 'package:mimir/life/lab_door/card.dart';
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
    final oaCredentials = ref.watch(CredentialsInit.storage.oa.$credentials);
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
                if (can(AppFeature.expenseRecords, ref)) const ExpenseRecordsAppCard(),
                if (can(AppFeature.electricityBalance, ref)) const ElectricityBalanceAppCard(),
                if (can(AppFeature.mimirForum, ref)) const ForumAppCard(),
                if (!kIsWeb &&
                    oaCredentials != null &&
                    OpenLabDoorAppCard.isAvailable(oaAccount: oaCredentials.account))
                  const OpenLabDoorAppCard(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
