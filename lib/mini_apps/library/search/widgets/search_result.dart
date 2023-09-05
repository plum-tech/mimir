import 'package:flutter/material.dart';

import '../../using.dart';
import '../entity/book_search.dart';
import '../init.dart';
import '../page/book_info.dart';
import '../utils.dart';
import 'search_result_item.dart';

class BookSearchResultWidget extends StatefulWidget {
  /// 要搜索的关键字
  final String keyword;

  /// 检索方式
  final SearchWay searchWay;

  final KeyClickCallback? requestQueryKeyCallback;

  const BookSearchResultWidget(
    this.keyword, {
    Key? key,
    this.requestQueryKeyCallback,
    this.searchWay = SearchWay.title,
  }) : super(key: key);

  @override
  State<BookSearchResultWidget> createState() => _BookSearchResultWidgetState();
}

class _BookSearchResultWidgetState extends State<BookSearchResultWidget> {
  /// 滚动控制器，用于监测滚动到底部，触发自动加载
  final _scrollController = ScrollController();

  /// 每页加载的最大长度
  static const sizePerPage = 30;

  // 本次搜索产生的搜索信息
  var useTime = 0.0;
  var searchResultCount = 0;
  var currentPage = 1;
  var totalPage = 10;

  /// 最终前端展示的数据
  List<BookImageHolding> dataList = [];

  /// 是否处于加载状态
  bool isLoading = false;

  /// 是否是成功加载第一页
  bool firstPageLoaded = false;

  /// 当前的搜索方式
  late SearchWay currentSearchWay;

  /// 获得搜索结果
  Future<List<BookImageHolding>> _get(int rows, int page) async {
    final searchResult = await LibrarySearchInit.bookSearch.search(
      keyword: widget.keyword,
      rows: rows,
      page: page,
      searchWay: currentSearchWay,
    );

    // 页数越界
    if (searchResult.currentPage > totalPage) {
      return [];
    }
    useTime = searchResult.useTime;
    searchResultCount = searchResult.resultCount;
    currentPage = searchResult.currentPage;
    totalPage = searchResult.totalPages;

    Log.info(searchResult);
    return await BookImageHolding.simpleQuery(
      LibrarySearchInit.bookImageSearch,
      LibrarySearchInit.holdingPreview,
      searchResult.books,
    );
  }

  /// 用于第一次获取数据
  Future<void> getData() async {
    isLoading = true;
    try {
      final firstPage = await _get(sizePerPage, currentPage);
      setState(() {
        firstPageLoaded = true;
        isLoading = false;
        dataList = firstPage;
      });
    } catch (e) {
      setState(() {
        firstPageLoaded = true;
        isLoading = false;
        dataList = [];
      });
    }
  }

  /// 用于后续每次触发加载更多
  Future<void> getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      context.showSnackBar(
          Row(
            children: [
              const LoadingPlaceholder.drop(),
              const SizedBox(
                width: 15,
              ),
              const Text('正在加载更多结果')
            ],
          ),
          duration: const Duration(seconds: 3));
      try {
        final nextPage = await _get(sizePerPage, currentPage + 1);
        if (nextPage.isNotEmpty) {
          setState(() {
            dataList.addAll(nextPage);
            isLoading = false;
          });
        } else {
          if (!mounted) return;
          context.showSnackBar(const Text('找不到更多了'));
          isLoading = false;
        }
      } catch (e) {
        context.showSnackBar(const Text('网络异常，再试一次'));
        isLoading = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentSearchWay = widget.searchWay;
    // 获取第一页数据
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Log.info('页面滑动到底部');
        // 获取下一页数据
        getMore();
      }
    });
  }

  Widget buildListView() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
        child: InkWell(
          child: BookItemWidget(
            dataList[index],
            onAuthorTap: widget.requestQueryKeyCallback,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return BookInfoPage(dataList[index]);
              }),
            );
          },
        ),
      ),
      itemCount: dataList.length,
      controller: _scrollController,
      separatorBuilder: (context, index) => Divider(color: Theme.of(context).primaryColor),
    );
  }

  Widget buildNotFound() {
    return const Center(
      child: Text('搜索结果为空'),
    );
  }

  /// 搜书页面 搜索框下部选择
  /// TODO: 改成 DefaultTabContainer
  Widget buildSearchWaySelector() {
    final textStyle = Theme.of(context).textTheme.headlineMedium;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: <List<dynamic>>[
          ['任意词', SearchWay.any],
          ['标题名', SearchWay.title],
          ['作者名', SearchWay.author],
          ['ISBN号', SearchWay.isbn],
        ].map((e) {
          String searchWayName = e[0];
          SearchWay searchWay = e[1];
          return Expanded(
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: searchWay == currentSearchWay ? primaryColor : Colors.white), // border: Border.all(),
                child: Center(
                  child: Text(searchWayName,
                      style: textStyle?.copyWith(color: e[1] == currentSearchWay ? Colors.white : Colors.black)),
                ),
              ),
              onTap: () {
                if (firstPageLoaded) {
                  setState(() {
                    currentSearchWay = e[1];
                    firstPageLoaded = false;
                    dataList = [];
                    getData();
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Log.info('初始化列表');
    return Column(
      children: [
        buildSearchWaySelector(),
        Text('总结果数: $searchResultCount  用时: $useTime  已加载: $currentPage/$totalPage'),
        Expanded(
          child: firstPageLoaded
              ? (dataList.isEmpty ? buildNotFound() : buildListView())
              : const LoadingPlaceholder.drop(),
        ),
      ],
    );
  }
}
