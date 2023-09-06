import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

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
