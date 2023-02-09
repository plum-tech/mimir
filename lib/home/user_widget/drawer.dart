import 'package:flutter/material.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/route.dart';
import 'package:mimir/storage/init.dart';
import 'package:rettulf/rettulf.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final installTime = Kv.home.installTime ?? DateTime.now();
    final inDays = DateTime.now().difference(installTime).inDays;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: context.themeColor),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(inDays <= 0 ? i18n.daysAppWithYouLabel0 : i18n.daysAppWithYouLabel(inDays),
                    style: Theme.of(context).textTheme.headlineSmall)),
          ),
          ListTile(
            title: Text(i18n.settings),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.settings);
            },
          ),
          ListTile(
            title: i18n.networkTool.text(),
            leading: const Icon(Icons.lan),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.networkTool);
            },
          ),
        ],
      ),
    );
  }
}
