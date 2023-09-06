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
  final ({Iterable<T> history, HistoryBuilder<T> builder})? searchHistory;
  final Iterable<T> candidates;
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
    required this.maxCrossAxisExtent,
    required this.childAspectRatio,
    super.keyboardType,
  });

  factory ItemSearchDelegate.highlight({
    required ItemBuilder itemBuilder,
    required Iterable<T> candidates,

    /// Using [String.contains] by default.
    ItemFilter<String>? filter,
    Iterable<T>? searchHistory,
    QueryProcessor? queryProcessor,
    required double maxCrossAxisExtent,
    required double childAspectRatio,
    TextInputType? keyboardType,

    /// Using [Object.toString] by default.
    Stringifier<T>? stringifier,
    TextStyle? plainStyle,
    TextStyle? highlightedStyle,
  }) {
    return ItemSearchDelegate(
      maxCrossAxisExtent: maxCrossAxisExtent,
      childAspectRatio: childAspectRatio,
      queryProcessor: queryProcessor,
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
        final highlighted = highlight(
          ctx,
          candidate: candidate,
          query: query,
          plainStyle: plainStyle,
          highlightedStyle: highlightedStyle,
        );
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

  Widget buildSearchHistory(BuildContext ctx, Iterable<T> history, HistoryBuilder<T> builder) {
    final query = realQuery;
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
    final query = realQuery;
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

Widget highlight(
  BuildContext ctx, {
  required String candidate,
  required String query,
  TextStyle? plainStyle,
  TextStyle? highlightedStyle,
}) {
  final parts = candidate.split(query);
  final texts = <TextSpan>[];
  for (var i = 0; i < parts.length; i++) {
    // TODO: Color issue in light mode.
    texts.add(TextSpan(text: parts[i], style: plainStyle ?? TextStyle(color: Colors.grey.withOpacity(0.5))));
    if (i < parts.length - 1) {
      texts.add(TextSpan(text: query, style: highlightedStyle));
    }
  }
  return RichText(text: TextSpan(children: texts));
}
