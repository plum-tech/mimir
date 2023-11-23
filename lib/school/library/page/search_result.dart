import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/common.dart';

import '../entity/book_search.dart';
import '../init.dart';
import 'book_info.dart';
import '../utils.dart';

class BookSearchResultWidget extends StatefulWidget {
  /// 要搜索的关键字
  final String keyword;

  /// 检索方式
  final SearchMethod initialSearchMethod;

  final KeyClickCallback? requestQueryKeyCallback;

  const BookSearchResultWidget(
    this.keyword, {
    super.key,
    this.requestQueryKeyCallback,
    this.initialSearchMethod = SearchMethod.title,
  });

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
  List<BookImageHolding> books = [];

  /// 是否处于加载状态
  bool isFetching = false;

  /// 是否是成功加载第一页
  bool firstPageLoaded = false;

  /// 当前的搜索方式
  late SearchMethod selectedSearchMethod;

  @override
  void initState() {
    super.initState();
    selectedSearchMethod = widget.initialSearchMethod;
    // 获取第一页数据
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        debugPrint('页面滑动到底部');
        // 获取下一页数据
        getMore();
      }
    });
  }

  /// 获得搜索结果
  Future<List<BookImageHolding>> _get(int rows, int page) async {
    final searchResult = await LibraryInit.bookSearch.search(
      keyword: widget.keyword,
      rows: rows,
      page: page,
      searchWay: selectedSearchMethod,
    );

    // 页数越界
    if (searchResult.currentPage > totalPage) {
      return [];
    }
    useTime = searchResult.useTime;
    searchResultCount = searchResult.resultCount;
    currentPage = searchResult.currentPage;
    totalPage = searchResult.totalPages;

    debugPrint(searchResult.toString());
    return await BookImageHolding.simpleQuery(
      LibraryInit.bookImageSearch,
      LibraryInit.holdingPreview,
      searchResult.books,
    );
  }

  /// 用于第一次获取数据
  Future<void> getData() async {
    isFetching = true;
    try {
      final firstPage = await _get(sizePerPage, currentPage);
      setState(() {
        firstPageLoaded = true;
        isFetching = false;
        books = firstPage;
      });
    } catch (e) {
      setState(() {
        firstPageLoaded = true;
        isFetching = false;
        books = [];
      });
    }
  }

  /// 用于后续每次触发加载更多
  Future<void> getMore() async {
    if (!isFetching) {
      setState(() {
        isFetching = true;
      });
      try {
        final nextPage = await _get(sizePerPage, currentPage + 1);
        if (nextPage.isNotEmpty) {
          setState(() {
            books.addAll(nextPage);
            isFetching = false;
          });
        } else {
          if (!mounted) return;
          context.showSnackBar(content: const Text('找不到更多了'));
          isFetching = false;
        }
      } catch (e) {
        context.showSnackBar(content: const Text('网络异常，再试一次'));
        isFetching = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('初始化列表');
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: buildSearchMethodSwitcher(),
          ),
          if (books.isEmpty)
            SliverFillRemaining(
              child: LeavingBlank(
                icon: Icons.inbox_outlined,
                desc: "No books",
              ),
            )
          else
            SliverList.builder(
                itemCount: books.length,
                itemBuilder: (ctx, i) {
                  final book = books[i];
                  return InkWell(
                    child: BookCard(
                      book,
                      onAuthorTap: widget.requestQueryKeyCallback,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return BookInfoPage(book);
                        }),
                      );
                    },
                  );
                })
        ],
      ),
      bottomNavigationBar: isFetching
          ? const PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: LinearProgressIndicator(),
            )
          : null,
    );
  }

  Widget buildSearchMethodSwitcher() {
    return [SearchMethod.any, SearchMethod.title, SearchMethod.author, SearchMethod.isbn]
        .map((method) {
          return ChoiceChip(
            label: method.l10nName().text(),
            selected: selectedSearchMethod == method,
            onSelected: (value) {
              setState(() {
                selectedSearchMethod = method;
                firstPageLoaded = false;
                books = [];
              });
              getData();
            },
          );
        })
        .toList()
        .wrap(spacing: 4);
  }
}

typedef KeyClickCallback = void Function(String key);

class BookCard extends StatelessWidget {
  final BookImageHolding bookImageHolding;

  final KeyClickCallback? onAuthorTap;

  const BookCard(
    this.bookImageHolding, {
    super.key,
    this.onAuthorTap,
  });

  /// 构造图书封皮预览图片
  Widget buildBookCover(String? imageUrl) {
    const def = Icon(Icons.library_books_sharp, size: 100);
    if (imageUrl == null) {
      return def;
    }

    return Image.network(
      imageUrl,
      // fit: BoxFit.fill,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return def;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildListTile(context, bookImageHolding);
  }

  /// 构造一个图书项
  Widget buildListTile(BuildContext context, BookImageHolding bi) {
    final screenHeight = MediaQuery.of(context).size.height;
    final book = bi.book;
    final holding = bi.holding ?? [];
    // 计算总共馆藏多少书
    int copyCount = holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount = holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    final row = Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(5),
            height: screenHeight / 5,
            child: buildBookCover(bi.image?.resourceLink),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.title),
              onAuthorTap == null
                  ? Text('作者:  ${book.author}')
                  : Row(
                      children: [
                        const Text('作者:  '),
                        InkWell(
                          child: Text(book.author, style: const TextStyle(color: Colors.blue)),
                          onTap: () {
                            onAuthorTap!(book.author);
                          },
                        ),
                      ],
                    ),
              Text('索书号:  ${book.callNo}'),
              Text('ISBN:  ${book.isbn}'),
              Text('${book.publisher}  ${book.publishDate}'),
              Row(
                children: [
                  const Expanded(child: Text(' ')),
                  ColoredBox(
                    color: Colors.black12,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                      // width: 80,
                      // height: 20,
                      child: Text('馆藏($copyCount)/在馆($loanableCount)'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    return row;
  }
}
