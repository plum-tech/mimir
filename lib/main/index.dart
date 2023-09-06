import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/timetable/i18n.dart' as $timetable;
import 'package:mimir/school/i18n.dart' as $school;
import 'package:mimir/life/i18n.dart' as $life;
import 'package:mimir/me/i18n.dart' as $me;

class MainStagePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainStagePage({super.key, required this.navigationShell});

  @override
  State<MainStagePage> createState() => _MainStagePageState();
}

class _MainStagePageState extends State<MainStagePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var currentStage = 0;
  late var items = buildItems();

  List<({String route, BottomNavigationBarItem item})> buildItems() {
    return [
      (
        route: "/timetable",
        item: BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: $timetable.i18n.navigation,
        )
      ),
      (
        route: "/school",
        item: BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: $school.i18n.navigation,
        )
      ),
      (
        route: "/life",
        item: BottomNavigationBarItem(
          icon: Icon(Icons.spa_outlined),
          activeIcon: Icon(Icons.spa),
          label: $life.i18n.navigation,
        )
      ),
      (
        route: "/me",
        item: BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: $me.i18n.navigation,
        )
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    items = buildItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.navigationShell,
      ),
      bottomNavigationBar: buildButtonNavigationBar(),
    );
  }

  Widget buildButtonNavigationBar() {
    return BottomNavigationBar(
      useLegacyColorScheme: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      currentIndex: getSelectedIndex(),
      onTap: onItemTapped,
      items: items.map((e) => e.item).toList(),
    );
  }

  int getSelectedIndex() {
    final location = GoRouterState.of(context).uri.toString();
    return items.indexWhere((e) => location.startsWith(e.route));
  }

  void onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
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
