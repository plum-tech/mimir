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
  final String? invalidSearchTip;

  /// If this is given, it means user can send a empty query without suggestion limitation.
  /// If so, this object will be returned.
  final Object? emptyIndicator;

  ItemSearchDelegate({
    required this.candidateBuilder,
    required this.candidates,
    required this.filter,
    this.searchHistory,
    this.queryProcessor,
    required this.maxCrossAxisExtent,
    required this.childAspectRatio,
    this.emptyIndicator,
    this.invalidSearchTip,
    super.keyboardType,
  });

  factory ItemSearchDelegate.highlight({
    required ItemBuilder itemBuilder,
    required List<T> candidates,

    /// Using [String.contains] by default.
    ItemFilter<String>? filter,
    List<T>? searchHistory,
    QueryProcessor? queryProcessor,
    required double maxCrossAxisExtent,
    required double childAspectRatio,
    Object? emptyIndicator,
    String? invalidSearchTip,
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
      invalidSearchTip: invalidSearchTip,
      emptyIndicator: emptyIndicator,
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
        if (query.isEmpty) return false;
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
    if (T == String && filter(query, query as T)) {
      return const SizedBox();
    }
    if (query.isEmpty && emptyIndicator != null) {
      return const SizedBox();
    }
    return LeavingBlank(icon: Icons.search_off_rounded, desc: invalidSearchTip);
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    final query = realQuery;
    if (T == String && filter(query, query as T)) {
      close(context, query);
      return;
    }
    if (query.isEmpty && emptyIndicator != null) {
      close(context, emptyIndicator);
      return;
    }
  }

  Widget buildSearchHistory(BuildContext ctx, List<T> history, HistoryBuilder<T> builder) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio),
      itemCount: history.length,
      itemBuilder: (ctx, i) {
        final item = history[i];
        return builder(ctx, item, () => close(ctx, item));
      },
    );
  }

  Widget buildCandidateList(BuildContext ctx) {
    final query = realQuery;
    final matched = candidates.where((candidate) => filter(query, candidate)).toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio),
      itemCount: matched.length,
      itemBuilder: (ctx, i) {
        final candidate = matched[i];
        return candidateBuilder(ctx, candidate, query, () => close(ctx, candidate));
      },
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
