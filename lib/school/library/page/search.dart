import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/school/library/storage/search.dart';
import 'package:sit/school/library/widgets/search.dart';

import '../entity/search.dart';
import '../init.dart';
import '../i18n.dart';
import 'search_result.dart';

class LibrarySearchDelegate extends SearchDelegate<String> {
  final $searchMethod = ValueNotifier(SearchMethod.any);

  @override
  void dispose() {
    $searchMethod.dispose();
    super.dispose();
  }

  void searchByGiving(
    BuildContext context, {
    required String keyword,
    SearchMethod? searchMethod,
  }) async {
    if (searchMethod != null) {
      $searchMethod.value = searchMethod;
    }
    query = keyword.trim();

    showSuggestions(context);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      PlatformIconButton(
        icon: Icon(context.icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return PlatformIconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        if (query.isEmpty) {
          close(context, '');
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    addHistory(query, $searchMethod.value);
  }

  Future<void> addHistory(String keyword, SearchMethod searchMethod) async {
    keyword = keyword.trim();
    if (keyword.isEmpty) return;
    await LibraryInit.searchStorage.addSearchHistory(SearchHistoryItem(
      keyword: keyword,
      searchMethod: searchMethod,
      time: DateTime.now(),
    ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return BookSearchResultWidget(
      query: query,
      onSearchTap: (method, keyword) {
        searchByGiving(
          context,
          keyword: keyword,
          searchMethod: method,
        );
      },
      $searchMethod: $searchMethod,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ($searchMethod >>
                  (ctx, _) => SearchMethodSwitcher(
                        selected: $searchMethod.value,
                        onSelect: (newSelection) {
                          $searchMethod.value = newSelection;
                        },
                      ))
              .sized(h: 40),
        ),
        SliverToBoxAdapter(
          child: LibrarySearchHistoryGroup(
            onTap: (method, title) => searchByGiving(context, keyword: title, searchMethod: method),
          ),
        ),
        SliverToBoxAdapter(
          child: LibraryTrendsGroup(onTap: (title) => searchByGiving(context, keyword: title)),
        )
      ],
    );
  }
}

class LibraryTrendsGroup extends StatefulWidget {
  final void Function(String keyword)? onTap;

  const LibraryTrendsGroup({
    super.key,
    this.onTap,
  });

  @override
  State<LibraryTrendsGroup> createState() => _LibraryTrendsGroupState();
}

class _LibraryTrendsGroupState extends State<LibraryTrendsGroup> {
  LibraryTrends? trends = LibraryInit.searchStorage.getTrends();
  bool recentOrTotal = true;

  @override
  void initState() {
    super.initState();
    fetchHotSearch();
  }

  Future<void> fetchHotSearch() async {
    final trends = await LibraryInit.hotSearchService.getTrends();
    await LibraryInit.searchStorage.setTrends(trends);
    if (!mounted) return;
    setState(() {
      this.trends = trends;
    });
  }

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;
    final trends = this.trends;
    return SuggestionItemView<LibraryTrendsItem>(
      tileLeading: Icon(recentOrTotal ? Icons.local_fire_department : Icons.people),
      title: recentOrTotal ? i18n.searching.trending.text() : i18n.searching.mostPopular.text(),
      tileTrailing: PlatformIconButton(
        icon: const Icon(Icons.swap_horiz),
        onPressed: () {
          setState(() {
            recentOrTotal = !recentOrTotal;
          });
        },
      ),
      items: recentOrTotal ? trends?.recent30days : trends?.total,
      itemBuilder: (ctx, item) {
        return ActionChip(
          label: item.keyword.text(),
          onPressed: () {
            onTap?.call(item.keyword);
          },
        );
      },
    );
  }
}

class LibrarySearchHistoryGroup extends StatefulWidget {
  final void Function(SearchMethod method, String keyword)? onTap;

  const LibrarySearchHistoryGroup({
    super.key,
    this.onTap,
  });

  @override
  State<LibrarySearchHistoryGroup> createState() => _LibrarySearchHistoryGroupState();
}

class _LibrarySearchHistoryGroupState extends State<LibrarySearchHistoryGroup> {
  List<SearchHistoryItem>? history = LibraryInit.searchStorage.getSearchHistory();
  final $history = LibraryInit.searchStorage.listenSearchHistory();

  @override
  void initState() {
    super.initState();
    $history.addListener(onChange);
  }

  @override
  void dispose() {
    $history.removeListener(onChange);
    super.dispose();
  }

  void onChange() {
    setState(() {
      history = LibraryInit.searchStorage.getSearchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;
    final history = this.history;
    return SuggestionItemView<SearchHistoryItem>(
      tileLeading: const Icon(Icons.history),
      title: i18n.searching.searchHistory.text(),
      items: history,
      tileTrailing: PlatformIconButton(
        icon: Icon(context.icons.delete),
        onPressed: history?.isNotEmpty == true
            ? () {
                LibraryInit.searchStorage.setSearchHistory(null);
              }
            : null,
      ),
      itemBuilder: (ctx, item) {
        return ActionChip(
          label: item.keyword.text(),
          onPressed: () {
            onTap?.call(item.searchMethod, item.keyword);
          },
        );
      },
    );
  }
}

class SuggestionItemView<T> extends StatelessWidget {
  final Widget title;
  final List<T>? items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final int limitLength;
  final Widget? tileTrailing;
  final Widget? tileLeading;

  const SuggestionItemView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.limitLength = 20,
    this.tileTrailing,
    this.tileLeading,
  });

  @override
  Widget build(BuildContext context) {
    final items = this.items;
    return [
      ListTile(
        leading: tileLeading,
        title: title,
        trailing: tileTrailing,
      ),
      AnimatedSwitcher(
        duration: Durations.medium2,
        child: items != null
            ? items
                .sublist(0, min(items.length, limitLength))
                .map((e) => itemBuilder(context, e))
                .toList(growable: false)
                .wrap(spacing: 4)
            : const SizedBox(),
      ).padH(8),
    ].column(caa: CrossAxisAlignment.start, mas: MainAxisSize.min);
  }
}
