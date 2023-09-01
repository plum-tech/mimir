import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/mini_apps/elec_bill/init.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import 'dashboard.dart';
import 'search.dart';

class ElectricityBillPage extends StatefulWidget {
  const ElectricityBillPage({super.key});

  @override
  State<StatefulWidget> createState() => _ElectricityBillPageState();
}

class _Page {
  static const bill = 0;
  static const search = 1;
}
// For now, we can't use AdaptiveUI.
class _ElectricityBillPageState extends State<ElectricityBillPage> {
  /// elevated the `room` to share the state
  /// Null means user should select a room number before all.
  String? _selectedRoom;
  final storage = ElectricityBillInit.electricityStorage;
  List<String>? _searchHistory;
  static List<String>? _allRoomNumbers;
  var _dashboardKey = GlobalKey();

  /// For landscape mode Full.
  int curNavigation = _Page.bill;

  Future<List> getRoomNumberList() async {
    String jsonData = await rootBundle.loadString("assets/room_list.json");
    List list = await jsonDecode(jsonData);
    return list;
  }

  @override
  void initState() {
    super.initState();
    final searchHistory = storage.searchHistory;
    if (searchHistory != null) {
      _searchHistory = searchHistory;
      if (searchHistory.isNotEmpty) {
        _selectedRoom = searchHistory.last;
      }
    }
    if (_allRoomNumbers == null) {
      getRoomNumberList().then((value) {
        _allRoomNumbers = value.map((e) => e.toString()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (ctx, orient) => orient == Orientation.portrait ? buildPortrait(ctx) : buildLandscape(ctx));
  }

  Widget buildPortrait(BuildContext context) {
    final selectedRoom = _selectedRoom;
    return Scaffold(
        appBar: AppBar(
          title: selectedRoom != null ? i18n.title(selectedRoom).text() : MiniApp.elecBill.l10nName().text(),
          actions: <Widget>[
            IconButton(
                onPressed: search,
                icon: const Icon(
                  Icons.search_rounded,
                )),
          ],
        ),
        body: selectedRoom == null
            ? EmptySearchTip(
                search: search,
              )
            : Dashboard(key: _dashboardKey, selectedRoom: selectedRoom));
  }

  Widget buildLandscape(BuildContext ctx) {
    final selectedRoom = _selectedRoom;
    final right = <Widget>[];
    if (selectedRoom == null) {
      right.add(EmptySearchTip(
        search: search,
      ));
      right.add(EmptySearchTip(
        search: search,
      ));
    } else {
      right.add(Dashboard(key: _dashboardKey, selectedRoom: selectedRoom));
      right.add(Search(
        searchHistory: _searchHistory ?? [selectedRoom],
        search: search,
        onSelected: selectRoomNumber,
      ));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: <Widget>[
          NavigationRail(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                ctx.navigator.pop();
              },
            ),
            selectedIndex: curNavigation,
            groupAlignment: 1.0,
            onDestinationSelected: (int index) {
              if (selectedRoom == null && index == _Page.search) {
                search();
              } else {
                setState(() {
                  curNavigation = index;
                });
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.electric_bolt_rounded),
                selectedIcon: const Icon(Icons.bolt_outlined),
                label: i18n.navigation.bill.text(),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.search_rounded),
                selectedIcon: const Icon(Icons.saved_search_rounded),
                label: i18n.navigation.search.text(),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          IndexedStack(
            index: curNavigation,
            children: right,
          ).expanded()
        ],
      ),
    );
  }

  void search() {
    final recentList = _searchHistory ?? [];
    showSearch(
      context: context,
      delegate: SimpleTextSearchDelegate(
        // 最近查询(需要从hive里获取)，也可留空
        recentList: recentList.reversed.toList(),
        searchItemBuilder: (ctx, item, highlight, onSelect) => HtmlWidget(
          highlight,
          textStyle: ctx.textTheme.titleMedium,
        ).padAll(2).elevatedBtn(onPressed: () {
          onSelect();
        }).padAll(5),
        // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
        suggestionList: _allRoomNumbers ?? [],
        // 只允许使用搜索建议里的
        onlyUseSuggestion: true,
        preprocess: _keepOnlyNumber,
        keyboardType: TextInputType.number,
        childAspectRatio: 2,
        maxCrossAxisExtent: 150.0,
      ),
    ).then((value) async {
      if (value is String) {
        selectRoomNumber(value);
      }
    });
  }

  // benchmark: 100,000,000 times, result: 1:40.946605 minutes, AMD Ryzen 9 5900X 12-Core
  // created by zzq
  String _keepOnlyNumber(String raw) {
    return String.fromCharCodes(raw.codeUnits.where((e) => e >= 48 && e < 58));
  }

  void selectRoomNumber(String roomNumber) {
    final recentList = _searchHistory ?? [];
    recentList.remove(roomNumber);
    recentList.add(roomNumber);
    storage.searchHistory = recentList;
    if (!mounted) return;
    if (_selectedRoom != roomNumber) {
      setState(() {
        _selectedRoom = roomNumber;
        curNavigation = _Page.bill;
        _dashboardKey = GlobalKey();
      });
    }
  }
}

/*
  // benchmark: 100,000,000 times, result: 1:06.313091 minutes, AMD Ryzen 9 5900X 12-Core
  // created by Liplum
  static const Set<String> _numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
    String _keepOnlyNumber(String raw) {
    final s = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      final char = raw[i];
      if (_numbers.contains(char)) {
        s.write(char);
      }
    }
    return s.toString();
  }
*/
