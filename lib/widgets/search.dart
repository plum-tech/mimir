import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/exam_arr/using.dart';
import 'package:rettulf/rettulf.dart';

class SimpleTextSearchDelegate<T> extends SearchDelegate {
  final List<T>? searchHistory;
  final List<T>? suggestions;
  final Widget Function(BuildContext ctx, T itemData, String highlighted, VoidCallback onSelect) itemBuilder;
  final String Function(T itemData)? stringify;
  final String Function(String raw)? inputPreprocess;
  final bool suggestionOnly;
  final double maxCrossAxisExtent;
  final double childAspectRatio;

  SimpleTextSearchDelegate({
    required this.itemBuilder,
    this.searchHistory,
    this.suggestions,
    this.stringify,
    this.inputPreprocess,
    this.suggestionOnly = true,
    this.maxCrossAxisExtent = 150.0,
    this.childAspectRatio = 2.0,
    super.keyboardType,
  });

  String get realQuery => inputPreprocess?.call(query) ?? query;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final dest = realQuery;
    final suggestions = this.suggestions;
    if (!suggestionOnly || (suggestions != null && suggestions.contains(dest))) {
      close(context, dest);
      return const SizedBox();
    } else {
      return LeavingBlank(icon: Icons.search_off_rounded, desc: "Please select one.");
    }
  }

  Widget buildSearchHistory(BuildContext context) {
    final searchHistory = this.searchHistory ?? const [];
    return ListView(
        children: searchHistory.map((e) {
      return itemBuilder(context, e, stringify!(e), () => close(context, e));
    }).toList());
  }

  String highlight(BuildContext ctx, String e) {
    final splitTextList = e.split(realQuery).map((e1) => "<span style='color:grey'>$e1</span>");
    final highlight = "<span style='color:${ctx.highlightColor};font-weight: bold'>$realQuery</span>";
    return splitTextList.join(highlight);
  }

  Widget buildSearchList(BuildContext context) {
    List<Widget> children = [];
    final stringify = this.stringify;
    final suggestions = this.suggestions ?? const [];
    for (int i = 0; i < suggestions.length; i++) {
      // 获取对象
      final item = suggestions[i];

      // 文档化对象
      final documented = stringify == null ? item.toString() : stringify(item);

      // 过滤
      if (!documented.contains(realQuery)) continue;

      // 高亮化
      final highlighted = highlight(context, documented);

      // 搜索结果Widget构建
      final widget = itemBuilder(context, item, highlighted, () => close(context, item));

      children.add(widget);
    }

    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio),
      children: children,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 用户未输入
    if (realQuery.isEmpty) {
      return buildSearchHistory(context);
    } else {
      return buildSearchList(context);
    }
  }
}

extension _CssColorEx on BuildContext {
  String get highlightColor => isDarkMode ? "white" : "black";
}
