import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/exam_arr/using.dart';
import 'package:rettulf/rettulf.dart';

typedef CandidateBuilder<T> = Widget Function(BuildContext ctx, T item, String query, VoidCallback selectIt);
typedef HistoryBuilder<T> = Widget Function(BuildContext ctx, T item, VoidCallback selectIt);
typedef Stringifier<T> = String Function(T item);
typedef QueryProcessor = String Function(String raw);
typedef ItemFilter<T> = bool Function(String query, T item);
typedef ItemBuilder = Widget Function(BuildContext ctx, VoidCallback selectIt, Widget child);

class ItemSearchDelegate<T> extends SearchDelegate {
  final ({List<T> history, HistoryBuilder<T> builder})? searchHistory;
  final List<T> candidates;
  final CandidateBuilder<T> candidateBuilder;
  final ItemFilter<T> filter;
  final QueryProcessor? queryProcessor;
  final double maxCrossAxisExtent;
  final double childAspectRatio;

  ItemSearchDelegate({
    required this.candidateBuilder,
    required this.candidates,
    required this.filter,
    this.searchHistory,
    this.queryProcessor,
    this.maxCrossAxisExtent = 150.0,
    this.childAspectRatio = 2.0,
    super.keyboardType,
  });

  factory ItemSearchDelegate.highlight({
    required ItemBuilder itemBuilder,
    required List<T> candidates,

    /// Using [String.contains] by default.
    ItemFilter<String>? filter,
    List<T>? searchHistory,
    QueryProcessor? queryProcessor,
    double maxCrossAxisExtent = 150.0,
    double childAspectRatio = 2.0,
    TextInputType? keyboardType,

    /// Using [Object.toString] by default.
    Stringifier<T>? stringifier,
    TextStyle? highlightedStyle,
  }) {
    return ItemSearchDelegate(
      candidates: candidates,
      searchHistory: searchHistory == null
          ? null
          : (
              history: searchHistory,
              builder: (ctx, item, selectIt) {
                final candidate = stringifier?.call(item) ?? item.toString();
                return itemBuilder(ctx, selectIt, candidate.text());
              }
            ),
      filter: (query, item) {
        final candidate = stringifier?.call(item) ?? item.toString();
        if (filter == null) return candidate.contains(query);
        return filter(query, candidate);
      },
      candidateBuilder: (ctx, item, query, selectIt) {
        final candidate = stringifier?.call(item) ?? item.toString();
        final highlighted = highlight(ctx, candidate, query, highlightedStyle);
        return itemBuilder(ctx, selectIt, highlighted);
      },
    );
  }

  String get realQuery => queryProcessor?.call(query) ?? query;

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
    final query = realQuery;
    final suggestions = this.candidates;
    if (suggestions.contains(query)) {
      close(context, query);
      return const SizedBox();
    } else {
      return LeavingBlank(icon: Icons.search_off_rounded, desc: "Please select one.");
    }
  }

  Widget buildSearchHistory(BuildContext ctx, List<T> history, HistoryBuilder<T> builder) {
    List<Widget> children = [];
    for (final item in history) {
      if (!filter(realQuery, item)) continue;
      final widget = builder(ctx, item, () => close(ctx, item));
      children.add(widget);
    }
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio),
      children: children,
    );
  }

  Widget buildCandidateList(BuildContext ctx) {
    List<Widget> children = [];
    for (final candidate in candidates) {
      if (!filter(realQuery, candidate)) continue;
      final widget = candidateBuilder(ctx, candidate, query, () => close(ctx, candidate));
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
    final searchHistory = this.searchHistory;
    if (realQuery.isEmpty && searchHistory != null) {
      return buildSearchHistory(context, searchHistory.history, searchHistory.builder);
    } else {
      return buildCandidateList(context);
    }
  }
}

Widget highlight(BuildContext ctx, String candidate, String query, TextStyle? highlightedStyle) {
  final parts = candidate.split(query);
  final texts = <TextSpan>[];
  highlightedStyle ??= TextStyle(color: ctx.colorScheme.onTertiary);
  for (var i = 0; i < parts.length; i++) {
    texts.add(TextSpan(text: parts[i]));
    if (i < parts.length - 1) {
      texts.add(TextSpan(text: query, style: highlightedStyle));
    }
  }
  return RichText(text: TextSpan(children: texts));
}
