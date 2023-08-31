import 'package:flutter/material.dart';
import 'package:mimir/main/desktop/page/index.dart';
import 'package:mimir/main/network_tool/page/index.dart';
import 'package:mimir/main/settings/page/index.dart';
import 'package:rettulf/rettulf.dart';
import "./i18n.dart";

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: buildStage(),
      ),
    );
  }

  Widget buildDrawer() {
    return NavigationDrawer(
      selectedIndex: currentStage,
      onDestinationSelected: (i) {
        setState(() {
          currentStage = i;
        });
        drawerDelegate.closeDrawer();
      },
      children: [
        DrawerHeader(child: "".text()),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_rounded),
          label: i18n.home.text(),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.lan),
          label: i18n.networkTool.text(),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings),
          label: i18n.settings.text(),
        ),
      ],
    );
  }

  Widget buildStage() {
    switch (currentStage) {
      case _Stage.home:
        return Homepage(drawer: drawerDelegate);
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
