import 'package:flutter/material.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/life/electricity/index.dart';
import 'package:mimir/life/expense_records/index.dart';
import 'package:mimir/settings/settings.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';

class LifePage extends StatefulWidget {
  const LifePage({super.key});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  LoginStatus? loginStatus;
  final $campus = Settings.$campus;

  @override
  void initState() {
    $campus.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    $campus.removeListener(refresh);
    super.dispose();
  }

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

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final campus = Settings.campus;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          snap: false,
          floating: false,
          title: i18n.navigation.text(),
        ),
        if (loginStatus != LoginStatus.never)
          const SliverToBoxAdapter(
            child: ExpenseRecordsAppCard(),
          ),
        if (campus.capability.enableElectricity)
          const SliverToBoxAdapter(
            child: ElectricityBalanceAppCard(),
          ),
      ],
    );
  }
}
