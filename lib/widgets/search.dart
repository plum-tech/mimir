import 'package:flutter/material.dart';
import 'package:mimir/module/exam_arr/using.dart';
import 'package:rettulf/rettulf.dart';

/// 搜索对象的WidgetBuilder
typedef SearchItemBuilder<T> = Widget Function(BuildContext ctx, T itemData, String highlighted, VoidCallback onSelect);

/// 搜索对象文档化
typedef SearchItemDocumented<T> = String Function(T itemData);
typedef TextPreprocessing = String Function(String raw);

class SimpleTextSearchDelegate<T> extends SearchDelegate {
  final List<T> recentList, suggestionList;
  SearchItemBuilder<T> searchItemBuilder;
  SearchItemDocumented<T>? searchItemDocumented;
  TextPreprocessing? preprocess;
  final bool onlyUseSuggestion;
  final double maxCrossAxisExtent;
  final double childAspectRatio;

  SimpleTextSearchDelegate({
    required this.recentList,
    required this.suggestionList,
    required this.searchItemBuilder,
    this.searchItemDocumented,
    this.preprocess,
    this.onlyUseSuggestion = true,
    this.maxCrossAxisExtent = 150.0,
    this.childAspectRatio = 2.0,
    super.keyboardType,
  }) {
    searchItemDocumented ??= (item) => item.toString();
  }

  String get realQuery => preprocess?.call(query) ?? query;

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
    if (!onlyUseSuggestion || suggestionList.contains(dest)) {
      close(context, dest);
      return Container();
    } else {
      return LeavingBlank(icon: Icons.search_off_rounded, desc: "Please select one.");
    }
  }

  Widget buildRecentList(BuildContext context) {
    return ListView(
        children: recentList.map((e) {
      return searchItemBuilder(context, e, searchItemDocumented!(e), () => close(context, e));
    }).toList());
  }

  String highlight(BuildContext ctx, String e) {
    final splitTextList = e.split(realQuery).map((e1) => "<span style='color:grey'>$e1</span>");
    final highlight = "<span style='color:${ctx.highlightColor};font-weight: bold'>$realQuery</span>";
    return splitTextList.join(highlight);
  }

  Widget buildSearchList(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < suggestionList.length; i++) {
      // 获取对象
      final item = suggestionList[i];

      // 文档化对象
      final documented = searchItemDocumented!(item);

      // 过滤
      if (!documented.contains(realQuery)) continue;

      // 高亮化
      final highlighted = highlight(context, documented);

      // 搜索结果Widget构建
      final widget = searchItemBuilder(context, item, highlighted, () => close(context, item));

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
      return buildRecentList(context);
    } else {
      return buildSearchList(context);
    }
  }
}

extension _CssColorEx on BuildContext {
  String get highlightColor => isDarkMode ? "white" : "black";
}
