import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/life/electricity/index.dart';
import 'package:sit/life/expense_records/index.dart';
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
  LoginStatus? loginStatus;

  @override
  void didChangeDependencies() {
    final newLoginStatus = context.auth.loginStatus;
    if (loginStatus != newLoginStatus) {
      setState(() {
        loginStatus = newLoginStatus;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
              if (loginStatus != LoginStatus.never)
                const SliverToBoxAdapter(
                  child: ExpenseRecordsAppCard(),
                ),
              if (campus.capability.enableElectricity)
                const SliverToBoxAdapter(
                  child: ElectricityBalanceAppCard(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
