import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';

import '../entity/book_search.dart';
import '../init.dart';
import 'book_info.dart';
import '../utils.dart';

const _searchMethods = [
  SearchMethod.any,
  SearchMethod.title,
  SearchMethod.author,
  SearchMethod.isbn,
  SearchMethod.publisher,
];

class BookSearchResultWidget extends StatefulWidget {
  /// 要搜索的关键字
  final String query;

  /// 检索方式
  final SearchMethod initialSearchMethod;

  final void Function(String author)? onAuthorTap;

  const BookSearchResultWidget({
    required this.query,
    super.key,
    this.onAuthorTap,
    this.initialSearchMethod = SearchMethod.title,
  });

  @override
  State<BookSearchResultWidget> createState() => _BookSearchResultWidgetState();
}

class _BookSearchResultWidgetState extends State<BookSearchResultWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// 滚动控制器，用于监测滚动到底部，触发自动加载
  final scrollController = ScrollController();

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

  /// 当前的搜索方式
  late SearchMethod selectedSearchMethod;

  @override
  void initState() {
    super.initState();
    selectedSearchMethod = widget.initialSearchMethod;
    // Fetch the first page
    fetchNextPage();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// 获得搜索结果
  Future<List<BookImageHolding>> _get(int rows, int page) async {
    final searchResult = await LibraryInit.bookSearch.search(
      keyword: widget.query,
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
    currentPage = searchResult.currentPage + 1;
    totalPage = searchResult.totalPages;

    debugPrint(searchResult.toString());
    return await BookImageHolding.simpleQuery(
      searchResult.books,
    );
  }

  Future<void> fetchNextPage() async {
    if (isFetching) return;
    if (currentPage > totalPage) return;
    setState(() {
      isFetching = true;
    });
    try {
      final nextPage = await _get(sizePerPage, currentPage);
      if (!mounted) return;
      setState(() {
        books.addAll(nextPage);
        isFetching = false;
      });
    } catch (e) {
      isFetching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
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
                  return BookCard(
                    book,
                    onAuthorTap: widget.onAuthorTap,
                    onTap: () async {
                      await context.show$Sheet$((ctx) => BookInfoPage(book));
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
    return _searchMethods
        .map((method) {
          return ChoiceChip(
            label: method.l10nName().text(),
            selected: selectedSearchMethod == method,
            onSelected: (value) {
              setState(() {
                selectedSearchMethod = method;
                books = [];
                currentPage = 1;
              });
              fetchNextPage();
            },
          );
        })
        .toList()
        .wrap(spacing: 4);
  }
}

class BookCard extends StatelessWidget {
  final BookImageHolding bookImageHolding;
  final void Function()? onTap;
  final void Function(String author)? onAuthorTap;

  const BookCard(
    this.bookImageHolding, {
    super.key,
    this.onAuthorTap,
    this.onTap,
  });

  /// 构造图书封皮预览图片
  Widget buildBookCover(String? imageUrl) {
    const def = Icon(Icons.library_books_sharp);
    if (imageUrl == null) {
      return def;
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = bookImageHolding.book;
    final onAuthorTap = this.onAuthorTap;
    final holding = bookImageHolding.holding ?? const [];
    // 计算总共馆藏多少书
    int copyCount = holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount = holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
        leading: buildBookCover(bookImageHolding.image?.resourceLink),
        title: book.title.text(),
        onTap: onTap,
        subtitle: [
          if (onAuthorTap != null)
            RichText(
                text: TextSpan(
              style: const TextStyle(color: Colors.blue),
              text: book.author,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  onAuthorTap(book.author);
                },
            ))
          else
            book.author.text(),
          "${SearchMethod.isbn.l10nName()} ${book.isbn}".text(),
          "${SearchMethod.callNumber.l10nName()} ${book.callNo}".text(),
          "${book.publisher}  ${book.publishDate}".text(),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      ),
    );
  }
}
