import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

part 'env.dart';

typedef OrientAware<T> = T Function(bool isPortrait);
typedef PageBuilder = Widget Function(BuildContext ctx, Key key);

class AdaptivePage {
  final String label;
  final Widget unselectedIcon;
  final Widget selectedIcon;
  final String? tooltip;
  final PageBuilder builder;

  AdaptivePage({
    required this.label,
    this.tooltip,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.builder,
  });
}

/// Build the page inside of AdaptiveNavi, the GlobalKey is inside.
/// The navigation state will be remembered.
///
/// Side effect: All pages will be built at the same time.
/// So don't put something that will do heavy jobs in its [State.initState].
class AdaptiveNavi extends StatefulWidget {
  final List<AdaptivePage> pages;
  final int defaultIndex;
  final String title;
  final List<Widget>? actions;

  const AdaptiveNavi({
    super.key,
    required this.title,
    required this.pages,
    required this.defaultIndex,
    this.actions,
  });

  @override
  State<AdaptiveNavi> createState() => _AdaptiveNaviState();
}

class _AdaptiveNaviState extends State<AdaptiveNavi> {
  late int _curIndex = widget.defaultIndex;
  late final _pageKeys = List.generate(
    widget.pages.length,
    (index) => GlobalKey(debugLabel: "Page $index"),
  );
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = widget.pages.mapIndexed((index, p) => p.builder(context, _pageKeys[index])).toList();
  }

  @override
  void didUpdateWidget(covariant AdaptiveNavi oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.defaultIndex == oldWidget.defaultIndex, "defaultIndex can't be change");
  }

  @override
  Widget build(BuildContext context) {
    assert(pages.length == widget.pages.length);
    assert(_curIndex >= 0 && _curIndex < pages.length);
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title.text(),
        actions: widget.actions,
      ),
      body: IndexedStack(
        index: _curIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: widget.pages
            .map((p) => BottomNavigationBarItem(
                  label: p.label,
                  icon: p.unselectedIcon,
                  activeIcon: p.selectedIcon,
                  tooltip: p.tooltip,
                ))
            .toList(),
        currentIndex: _curIndex,
        onTap: (newIndex) {
          setState(() => _curIndex = newIndex);
        },
      ),
    );
  }

  Widget buildLandscape(BuildContext ctx) {
    Widget main = Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: <Widget>[
          NavigationRail(
            leading: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: i18n.back,
                onPressed: () {
                  final subpage = _pageKeys[_curIndex].currentState;
                  if (subpage is AdaptivePageProtocol) {
                    final subNavi = subpage.navigator;
                    if (subNavi != null && subNavi.canPop()) {
                      subNavi.pop();
                      return;
                    }
                  }
                  ctx.navigator.pop();
                },
              ),
              ...?widget.actions
            ].column(),
            selectedIndex: _curIndex,
            groupAlignment: 1.0,
            onDestinationSelected: (newIndex) {
              setState(() {
                _curIndex = newIndex;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: widget.pages
                .map(
                  (p) => NavigationRailDestination(
                    icon: p.unselectedIcon,
                    selectedIcon: p.selectedIcon,
                    label: p.label.text(),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),

          AdaptiveUI(
              isSubpage: true,
              child: IndexedStack(
                index: _curIndex,
                children: pages,
              )).expanded()
          // This is the main content.
        ],
      ),
    );
    main = WillPopScope(
        child: main,
        onWillPop: () async {
          final subpage = _pageKeys[_curIndex].currentState;
          if (subpage is AdaptivePageProtocol) {
            final subNavi = subpage.navigator;
            if (subNavi != null && subNavi.canPop()) {
              subNavi.pop();
              return false;
            }
          }
          return true;
        });
    return main;
  }
}
