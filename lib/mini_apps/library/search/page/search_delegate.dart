import 'package:flutter/material.dart';

import '../../using.dart';
import '../entity/book_search.dart';
import '../entity/hot_search.dart';
import '../entity/search_history.dart';
import '../init.dart';
import '../widgets/search_result.dart';
import '../widgets/suggestion_item.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  Widget? _suggestionView;

  /// 当前的搜索模式
  SearchWay _searchWay = SearchWay.any;

  /// 给定一个关键词，开始搜索该关键词
  void _searchByGiving(BuildContext context, String key, {SearchWay searchWay = SearchWay.any}) async {
    query = key;

    // 若已经显示过结果，这里无法直接再次显示结果
    // 经测试，需要先返回搜索建议页，在等待若干时间后显示结果
    showSuggestions(context);
    await Future.delayed(const Duration(seconds: 1));

    _searchWay = searchWay;
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
  Widget buildResults(BuildContext context) {
    LibrarySearchInit.librarySearchHistory.add(
      LibrarySearchHistoryItem()
        ..keyword = query
        ..time = DateTime.now(),
    );
    return BookSearchResultWidget(
      query,
      requestQueryKeyCallback: (String key) {
        _searchByGiving(
          context,
          key,
          searchWay: SearchWay.author,
        );
      },
      searchWay: _searchWay,
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
            const SizedBox(height: 20),
            Text('历史记录', style: Theme.of(context).textTheme.bodyLarge),
            SuggestionItemView(
              titleItems: LibrarySearchInit.librarySearchHistory.getAllByTimeDesc().map((e) => e.keyword).toList(),
              onItemTap: (title) => _searchByGiving(context, title),
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
                LibrarySearchInit.librarySearchHistory.deleteAll();
                close(context, '');
              },
            ),
            const SizedBox(height: 20),
            Text('大家都在搜', style: Theme.of(context).textTheme.bodyLarge),
            PlaceholderFutureBuilder<HotSearch>(
              future: LibrarySearchInit.hotSearchService.getHotSearch(),
              builder: (ctx, data, state) {
                if (data == null) return const CircularProgressIndicator();
                return SuggestionItemView(
                  titleItems: data.recentMonth.map((e) => e.hotSearchWord).toList(),
                  onItemTap: (title) => _searchByGiving(context, title),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
