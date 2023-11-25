import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/library/widgets/search.dart';

import '../entity/hot_search.dart';
import '../entity/search.dart';
import '../entity/history.dart';
import '../init.dart';
import 'search_result.dart';

class LibrarySearchDelegate extends SearchDelegate<String> {
  Widget? _suggestionView;

  /// 当前的搜索模式
  final $searchMethod = ValueNotifier(SearchMethod.any);

  /// 给定一个关键词，开始搜索该关键词
  void searchByGiving(
    BuildContext context, {
    required String keyword,
    SearchMethod? searchMethod,
  }) async {
    query = keyword;

    // 若已经显示过结果，这里无法直接再次显示结果
    // 经测试，需要先返回搜索建议页，在等待若干时间后显示结果
    showSuggestions(context);
    await Future.delayed(const Duration(seconds: 1));

    if (searchMethod != null) {
      $searchMethod.value = searchMethod;
    }
    if (!context.mounted) return;
    showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // 右侧的action区域，这里放置一个清除按钮
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
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
    LibraryInit.searchHistoryStorage.add(SearchHistoryItem(
      keyword: query,
      time: DateTime.now(),
      searchMethod: $searchMethod.value,
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
    // 第一次使用时，_suggestionView为空，那就构造，后面直接用
    _suggestionView ??= _buildSearchSuggestion(context);
    return _suggestionView!;
  }

  /// 构造下方搜索建议
  Widget _buildSearchSuggestion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ($searchMethod >>
                    (ctx, _) => SearchMethodSwitcher(
                          selected: $searchMethod.value,
                          onSelect: (newSelection) {
                            $searchMethod.value = newSelection;
                          },
                        ))
                .sized(h: 40),
            const SizedBox(height: 20),
            Text('历史记录', style: Theme.of(context).textTheme.bodyLarge),
            SuggestionItemView(
              titleItems: LibraryInit.searchHistoryStorage.getAllByTimeDesc().map((e) => e.keyword).toList(),
              onItemTap: (title) => searchByGiving(context, keyword: title),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.clear_all),
                  Text('清空搜索历史', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              onTap: () async {
                LibraryInit.searchHistoryStorage.deleteAll();
                close(context, '');
              },
            ),
            const SizedBox(height: 20),
            Text('大家都在搜', style: Theme.of(context).textTheme.bodyLarge),
            HotSearchGroup(onTap: (title) => searchByGiving(context, keyword: title)),
          ],
        ),
      ),
    );
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
  List<HotSearchItem>? hotSearch;

  @override
  void initState() {
    super.initState();
    fetchHotSearch();
  }

  Future<void> fetchHotSearch() async {
    final hotSearch = await LibraryInit.hotSearchService.getHotSearch();
    if (!context.mounted) return;
    setState(() {
      this.hotSearch = hotSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hotSearch = this.hotSearch;
    if (hotSearch == null) return const SizedBox();
    return SuggestionItemView(
      titleItems: hotSearch.map((e) => e.word).toList(),
      onItemTap: (title) => widget.onTap?.call(title),
    );
  }
}

class SuggestionItemView extends StatefulWidget {
  final void Function(String item)? onItemTap;
  final List<String> titleItems;
  final int limitLength;

  const SuggestionItemView({
    super.key,
    this.onItemTap,
    this.titleItems = const [],
    this.limitLength = 20,
  });

  @override
  State<SuggestionItemView> createState() => _SuggestionItemViewState();
}

class _SuggestionItemViewState extends State<SuggestionItemView> {
  bool showMore = false;

  Widget buildExpandButton() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: showMore
            ? [
                const Icon(Icons.expand_less),
                const Text('点击合起'),
              ]
            : [
                const Icon(Icons.expand_more),
                const Text('点击展开'),
              ],
      ),
      onTap: () {
        setState(() {
          showMore = !showMore;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.titleItems;
    // 没展开时候显示的数目
    int limitLength = items.length >= widget.limitLength ? widget.limitLength : items.length;
    // 根据情况切片到小于等于指定长度
    items = items.sublist(0, showMore ? items.length : limitLength);

    // 是否应当显示展开按钮
    // 只有当超过限制时才显示
    bool shouldShowExpandButton = widget.titleItems.length > widget.limitLength;
    return Column(
      children: [
        items
            .map((item) {
              return ActionChip(
                label: item.text(),
                onPressed: () {
                  if (widget.onItemTap != null) {
                    widget.onItemTap!(item);
                  }
                },
              );
            })
            .toList()
            .wrap(spacing: 4),
        shouldShowExpandButton ? buildExpandButton() : const SizedBox(),
      ],
    );
  }
}
