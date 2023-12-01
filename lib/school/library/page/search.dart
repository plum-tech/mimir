import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/library/storage/search.dart';
import 'package:sit/school/library/widgets/search.dart';

import '../entity/search.dart';
import '../init.dart';
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
    query = keyword;

    showSuggestions(context);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
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
    return [
      ($searchMethod >>
              (ctx, _) => SearchMethodSwitcher(
                    selected: $searchMethod.value,
                    onSelect: (newSelection) {
                      $searchMethod.value = newSelection;
                    },
                  ))
          .sized(h: 40),
      SearchHistoryGroup(
        onTap: (method, title) => searchByGiving(context, keyword: title, searchMethod: method),
      ),
      HotSearchGroup(onTap: (title) => searchByGiving(context, keyword: title)),
    ].column().scrolled();
  }
}

class HotSearchGroup extends StatefulWidget {
  final void Function(String keyword)? onTap;

  const HotSearchGroup({
    super.key,
    this.onTap,
  });

  @override
  State<HotSearchGroup> createState() => _HotSearchGroupState();
}

class _HotSearchGroupState extends State<HotSearchGroup> {
  HotSearch? hotSearch = LibraryInit.searchStorage.getHotSearch();
  bool recentOrTotal = true;

  @override
  void initState() {
    super.initState();
    fetchHotSearch();
  }

  Future<void> fetchHotSearch() async {
    final hotSearch = await LibraryInit.hotSearchService.getHotSearch();
    await LibraryInit.searchStorage.setHotSearch(hotSearch);
    if (!context.mounted) return;
    setState(() {
      this.hotSearch = hotSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;
    final hotSearch = this.hotSearch;
    return SuggestionItemView<HotSearchItem>(
      tileLeading: Icon(recentOrTotal ? Icons.local_fire_department : Icons.people),
      title: recentOrTotal ? "Recent hot".text() : "Most popular".text(),
      tileTrailing: IconButton(
        icon: const Icon(Icons.swap_horiz),
        onPressed: () {
          setState(() {
            recentOrTotal = !recentOrTotal;
          });
        },
      ),
      items: recentOrTotal ? hotSearch?.recent30days : hotSearch?.total,
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

class SearchHistoryGroup extends StatefulWidget {
  final void Function(SearchMethod method, String keyword)? onTap;

  const SearchHistoryGroup({
    super.key,
    this.onTap,
  });

  @override
  State<SearchHistoryGroup> createState() => _SearchHistoryGroupState();
}

class _SearchHistoryGroupState extends State<SearchHistoryGroup> {
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
      title: "Search history".text(),
      items: history,
      tileTrailing: IconButton(
        icon: const Icon(Icons.delete),
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
      AnimatedSize(
        duration: Durations.long2,
        curve: Curves.fastEaseInToSlowEaseOut,
        child: items != null
            ? items
                .sublist(0, min(items.length, limitLength))
                .map((e) => itemBuilder(context, e))
                .toList(growable: false)
                .wrap(spacing: 4)
            : const SizedBox(),
      ),
    ].column(caa: CrossAxisAlignment.start, mas: MainAxisSize.min);
  }
}
