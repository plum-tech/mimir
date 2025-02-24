import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/settings/settings.dart';
import 'package:rettulf/rettulf.dart';

import "../i18n.dart";

class LifeSettingsPage extends StatefulWidget {
  const LifeSettingsPage({
    super.key,
  });

  @override
  State<LifeSettingsPage> createState() => _LifeSettingsPageState();
}

class _LifeSettingsPageState extends State<LifeSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.navigation.text(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildElectricityAutoRefreshToggle(),
              buildExpenseAutoRefreshToggle(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildElectricityAutoRefreshToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => SwitchListTile.adaptive(
        secondary: Icon(context.icons.refresh),
        title: i18n.settings.electricity.autoRefresh.text(),
        subtitle: i18n.settings.electricity.autoRefreshDesc.text(),
        value: Settings.life.electricity.autoRefresh,
        onChanged: (newV) {
          setState(() {
            Settings.life.electricity.autoRefresh = newV;
          });
        },
      ),
    );
  }

  Widget buildExpenseAutoRefreshToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => SwitchListTile.adaptive(
        secondary: Icon(context.icons.refresh),
        title: i18n.settings.expense.autoRefresh.text(),
        subtitle: i18n.settings.expense.autoRefreshDesc.text(),
        value: Settings.life.expense.autoRefresh,
        onChanged: (newV) {
          setState(() {
            Settings.life.expense.autoRefresh = newV;
          });
        },
      ),
    );
  }
}
