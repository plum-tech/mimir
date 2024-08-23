import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/i18n.dart' as $timetable;
import 'package:sit/school/i18n.dart' as $school;
import 'package:sit/life/i18n.dart' as $life;
import 'package:sit/game/i18n.dart' as $game;
import 'package:sit/me/i18n.dart' as $me;
import 'package:sit/forum/i18n.dart' as $forum;
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

class MainStagePage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainStagePage({super.key, required this.navigationShell});

  @override
  ConsumerState<MainStagePage> createState() => _MainStagePageState();
}

typedef _NavigationDest = ({IconData icon, IconData activeIcon, String label});

extension _NavigationDestX on _NavigationDest {
  NavigationDestination toBarItem() {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(activeIcon),
      label: label,
    );
  }

  NavigationRailDestination toRailDest() {
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: Icon(activeIcon),
      label: label.text(),
    );
  }
}

typedef NavigationItems = List<({String route, _NavigationDest item})>;

class _MainStagePageState extends ConsumerState<MainStagePage> {
  var currentStage = 0;

  NavigationItems buildItems() {
    return [
      (
        route: "/timetable",
        item: (
          icon: Icons.calendar_month_outlined,
          activeIcon: Icons.calendar_month,
          label: $timetable.i18n.navigation,
        )
      ),
      if (!kIsWeb)
        (
          route: "/school",
          item: (
            icon: Icons.school_outlined,
            activeIcon: Icons.school,
            label: $school.i18n.navigation,
          )
        ),
      if (!kIsWeb)
        (
          route: "/life",
          item: (
            icon: Icons.spa_outlined,
            activeIcon: Icons.spa,
            label: $life.i18n.navigation,
          )
        ),
      // in-app webview only supports Android, and iOS
      if (false && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS))
        (
          route: "/forum",
          item: (
            icon: Icons.forum_outlined,
            activeIcon: Icons.forum,
            label: $forum.i18n.navigation,
          )
        ),
      if (ref.watch(Settings.game.$showGameNavigation) ?? true)
        (
          route: "/game",
          item: (
            icon: context.icons.game,
            activeIcon: context.icons.gameFilled,
            label: $game.i18n.navigation,
          )
        ),
      (
        route: "/me",
        item: (
          icon: context.icons.personOutline,
          activeIcon: context.icons.person,
          label: $me.i18n.navigation,
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = buildItems();
    if (context.isPortrait) {
      return Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: buildNavigationBar(items),
      );
    } else {
      return Scaffold(
        body: [
          buildNavigationRail(items),
          const VerticalDivider(),
          widget.navigationShell.expanded(),
        ].row(),
      );
    }
  }

  Widget buildNavigationBar(NavigationItems items) {
    return NavigationBar(
      selectedIndex: getSelectedIndex(items),
      onDestinationSelected: (index) => onItemTapped(index, items),
      destinations: items.map((e) => e.item.toBarItem()).toList(),
    );
  }

  Widget buildNavigationRail(NavigationItems items) {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      selectedIndex: getSelectedIndex(items),
      onDestinationSelected: (index) => onItemTapped(index, items),
      destinations: items.map((e) => e.item.toRailDest()).toList(),
    );
  }

  int getSelectedIndex(NavigationItems items) {
    final location = GoRouterState.of(context).uri.toString();
    return max(0, items.indexWhere((item) => location.startsWith(item.route)));
  }

  void onItemTapped(int index, NavigationItems items) {
    final item = items[index];
    final branchIndex = widget.navigationShell.route.routes.indexWhere((r) {
      if (r is GoRoute) {
        return r.path.startsWith(item.route);
      }
      return false;
    });
    widget.navigationShell.goBranch(
      branchIndex >= 0 ? branchIndex : index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
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
