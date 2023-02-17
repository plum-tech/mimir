import 'package:flutter/material.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/main/desktop/page/index.dart';
import 'package:mimir/main/network_tool/page/index.dart';
import 'package:mimir/main/settings/page/index.dart';
import 'package:rettulf/rettulf.dart';

class MainStagePage extends StatefulWidget {
  const MainStagePage({super.key});

  @override
  State<MainStagePage> createState() => _MainStagePageState();
}

class _Stage {
  const _Stage._();

  static const home = 0;
  static const networkTool = 1;
  static const settings = 2;
}

class _MainStagePageState extends State<MainStagePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final drawerDelegate = DrawerDelegate(scaffoldKey);
  var currentStage = _Stage.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: buildDrawer(),
      body: buildStage(),
    );
  }

  Widget buildDrawer() {
    final String currentVersion = 'v${Init.currentVersion.version} on ${Init.currentVersion.platform}';
    return NavigationDrawer(
      selectedIndex: currentStage,
      onDestinationSelected: (i) {
        setState(() {
          currentStage = i;
        });
      },
      children: [
        DrawerHeader(child: "Header".text()),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_rounded),
          label: "home".text(),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.lan),
          label: "network tool".text(),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings),
          label: "settings".text(),
        ),
        const Spacer(),
        ListTile(
          title: currentVersion.text(style: context.textTheme.titleSmall),
          leading: const Icon(Icons.settings_applications),
        ),
      ],
    );
  }

  Widget buildStage() {
    switch (currentStage) {
      case _Stage.home:
        return HomePage(drawer: drawerDelegate);
      case _Stage.networkTool:
        return NetworkToolPage(drawer: drawerDelegate);
      default:
        return SettingsPage(drawer: drawerDelegate);
    }
  }
}

abstract class DrawerDelegateProtocol {
  const DrawerDelegateProtocol();

  void openDrawer();

  void closeDrawer();

  void openEndDrawer();

  void closeEndDrawer();
}

class DrawerDelegate extends DrawerDelegateProtocol {
  final GlobalKey<ScaffoldState> key;

  const DrawerDelegate(this.key);

  @override
  void openDrawer() {
    key.currentState?.openDrawer();
  }

  @override
  void closeDrawer() {
    key.currentState?.closeDrawer();
  }

  @override
  void openEndDrawer() {
    key.currentState?.openEndDrawer();
  }

  @override
  void closeEndDrawer() {
    key.currentState?.closeEndDrawer();
  }
}
