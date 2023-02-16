import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/route.dart';
import 'package:rettulf/rettulf.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: context.themeColor),
            child: const SizedBox(),
          ),
          ListTile(
            title: "settings.title".tr().text(),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.settings);
            },
          ),
          ListTile(
            title: "networkTool.title".tr().text(),
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
