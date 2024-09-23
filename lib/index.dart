import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/feature/utils.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/i18n.dart' as $timetable;
import 'package:mimir/school/i18n.dart' as $school;
import 'package:mimir/life/i18n.dart' as $life;
import 'package:mimir/game/i18n.dart' as $game;
import 'package:mimir/me/i18n.dart' as $me;
import 'package:mimir/timetable/p13n/entity/background.dart';
import 'package:mimir/timetable/widget/timetable/background.dart';

// import 'package:mimir/backend/forum/i18n.dart' as $forum;
import 'package:rettulf/rettulf.dart';

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
  NavigationItems buildItems() {
    return [
      if (ref.watch(Settings.timetable.$showTimetableNavigation) && can(AppFeature.timetable, ref))
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
      // if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      //   (
      //     route: "/forum",
      //     item: (
      //       icon: Icons.forum_outlined,
      //       activeIcon: Icons.forum,
      //       label: $forum.i18n.navigation,
      //     )
      //   ),
      if (ref.watch(Settings.game.$showGameNavigation) && can(AppFeature.game$, ref))
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
    return buildBody();
    return [
      Positioned.fill(
        child: ColoredBox(color: context.colorScheme.surface),
      ),
      Positioned.fill(
        child: TimetableBackground(
          background: Settings.timetable.backgroundImage ?? BackgroundImage.disabled(),
        ),
      ),
      buildBody(),
    ].stack();
  }
  Widget buildBody() {
    final items = buildItems();
    if (context.isPortrait) {
      return Scaffold(
        // backgroundColor: Colors.transparent,
        body: widget.navigationShell,
        bottomNavigationBar: buildNavigationBar(items),
      );
    } else {
      return Scaffold(
        // backgroundColor: Colors.transparent,
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
      // backgroundColor: context.colorScheme.surfaceContainer.withOpacity(0.6),
      selectedIndex: getSelectedIndex(items),
      onDestinationSelected: (index) => onItemTapped(index, items),
      destinations: items.map((e) => e.item.toBarItem()).toList(),
    );
  }

  Widget buildNavigationRail(NavigationItems items) {
    return NavigationRail(
      // backgroundColor: context.colorScheme.surfaceContainer.withOpacity(0.6),
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
