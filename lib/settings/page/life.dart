import 'package:flutter/material.dart';
import 'package:mimir/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

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
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.life.title.text(style: context.textTheme.headlineSmall),
            ),
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
      builder: (ctx, setState) => ListTile(
        title: i18n.life.electricity.autoRefreshTitle.text(),
        subtitle: i18n.life.electricity.autoRefreshDesc.text(),
        leading: const Icon(Icons.refresh_outlined),
        trailing: Switch.adaptive(
          value: Settings.life.electricity.autoRefresh,
          onChanged: (newV) {
            setState(() {
              Settings.life.electricity.autoRefresh = newV;
            });
          },
        ),
      ),
    );
  }

  Widget buildExpenseAutoRefreshToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.life.expense.autoRefreshTitle.text(),
        subtitle: i18n.life.expense.autoRefreshDesc.text(),
        leading: const Icon(Icons.refresh_outlined),
        trailing: Switch.adaptive(
          value: Settings.life.expense.autoRefresh,
          onChanged: (newV) {
            setState(() {
              Settings.life.expense.autoRefresh = newV;
            });
          },
        ),
      ),
    );
  }
}
