import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/widgets/search.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

Future<String?> searchRoom({
  String? initial,
  required BuildContext ctx,
  required List<String> searchHistory,
  required List<String> roomList,
}) async {
  final result = await showSearch(
    context: ctx,
    query: initial,
    delegate: ItemSearchDelegate.highlight(
      // 最近查询(需要从hive里获取)，也可留空
      searchHistory: searchHistory,
      itemBuilder: (ctx, selectIt,child) {
        return child.elevatedBtn(onPressed: () {
          selectIt();
        }).padAll(5);
      },
      // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
      candidates: roomList,
      queryProcessor: _keepOnlyNumber,
      keyboardType: TextInputType.number,
      childAspectRatio: 2,
      maxCrossAxisExtent: 150.0,
    ),
  );
  return result is String ? result : null;
}

String _keepOnlyNumber(String raw) {
  return String.fromCharCodes(raw.codeUnits.where((e) => e >= 48 && e < 58));
}

class EmptySearchTip extends StatelessWidget {
  final VoidCallback? onSearch;

  const EmptySearchTip({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return LeavingBlank(icon: Icons.pageview_outlined, desc: i18n.initialTip, onIconTap: onSearch);
  }
}

class Search extends StatefulWidget {
  final List<String> searchHistory;
  final VoidCallback? onSearch;
  final void Function(String roomNumber)? onSelected;

  const Search({super.key, required this.searchHistory, this.onSearch, this.onSelected});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return [
      Icons.pageview_outlined.make(size: 120).padAll(20).on(tap: widget.onSearch).expanded(),
      [
        "Recent Search".text(style: context.textTheme.titleLarge).padAll(10),
        buildRecentSearch(context).padAll(10),
      ].column().expanded(),
    ].column(maa: MAAlign.spaceAround).center();
  }

  Widget buildRecentSearch(BuildContext ctx) {
    final recent = widget.searchHistory.getRange(0, min(3, widget.searchHistory.length));
    return recent
        .map((e) => e.text(style: ctx.textTheme.displayMedium).padAll(10).inCard(elevation: 5).onTap(() {
              widget.onSelected?.call(e);
            }))
        .toList()
        .row(maa: MainAxisAlignment.center);
  }
}
