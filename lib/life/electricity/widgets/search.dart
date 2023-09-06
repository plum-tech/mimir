import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/widgets/search.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

Future<String?> searchRoom({
  String? initial,
  required BuildContext ctx,
  required Iterable<String> searchHistory,
  required Iterable<String> roomList,
}) async {
  final result = await showSearch(
    context: ctx,
    query: initial,
    delegate: ItemSearchDelegate.highlight(
      searchHistory: searchHistory,
      itemBuilder: (ctx, selectIt, child) {
        return ElevatedButton(
          onPressed: () {
            selectIt();
          },
          child: child,
        ).padSymmetric(h: 6, v: 8);
      },
      candidates: roomList,
      queryProcessor: _keepOnlyNumber,
      keyboardType: TextInputType.number,
      invalidSearchTip: i18n.searchInvalidTip,
      childAspectRatio: 2,
      maxCrossAxisExtent: 150.0,
    ),
  );
  return result is String ? result : null;
}

String _keepOnlyNumber(String raw) {
  return String.fromCharCodes(raw.codeUnits.where((e) => e >= 48 && e < 58));
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
