import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';

import '../entity/search.dart';
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

  Future<void> fetchNextPage() async {
    if (isFetching) return;
    if (currentPage > totalPage) return;
    setState(() {
      isFetching = true;
    });
    try {
      final searchResult = await LibraryInit.bookSearch.search(
        keyword: widget.query,
        rows: sizePerPage,
        page: currentPage,
        searchMethod: selectedSearchMethod,
      );

      // 页数越界
      if (searchResult.currentPage > totalPage) {
        setState(() {
          isFetching = false;
        });
        return;
      } else {
        useTime = searchResult.useTime;
        searchResultCount = searchResult.resultCount;
        currentPage = searchResult.currentPage + 1;
        totalPage = searchResult.totalPages;

        debugPrint(searchResult.toString());
        final nextPage = await BookImageHolding.simpleQuery(
          searchResult.books,
        );
        if (!mounted) return;
        setState(() {
          books.addAll(nextPage);
          isFetching = false;
        });
      }
      setState(() {
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
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
            child: buildSearchMethodSwitcher().sized(h: 40),
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
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _searchMethods.length,
      itemBuilder: (ctx, i) {
        final method = _searchMethods[i];
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
        ).padH(4);
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final book = bookImageHolding.book;
    final onAuthorTap = this.onAuthorTap;
    final holding = bookImageHolding.holding ?? const [];
    final imgUrl = bookImageHolding.image?.resourceLink;
    // 计算总共馆藏多少书
    int copyCount = holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount = holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
        leading: imgUrl == null
            ? null
            : CachedNetworkImage(
                imageUrl: imgUrl,
                placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
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
          if (book.isbn.isNotEmpty) "${SearchMethod.isbn.l10nName()} ${book.isbn}".text(),
          "${SearchMethod.callNumber.l10nName()} ${book.callNo}".text(),
          "${book.publisher}  ${book.publishDate}".text(),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      ),
    );
  }
}
