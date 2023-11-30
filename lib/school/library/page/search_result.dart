import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/library/page/details.model.dart';
import 'package:sit/school/library/widgets/search.dart';

import '../entity/search.dart';
import '../init.dart';
import 'details.dart';
import '../utils.dart';

typedef BookSearchCallback = void Function(SearchMethod method, String keyword);

class BookSearchResultWidget extends StatefulWidget {
  final String query;

  final ValueNotifier<SearchMethod> $searchMethod;

  final BookSearchCallback? onSearchTap;

  const BookSearchResultWidget({
    required this.query,
    required this.$searchMethod,
    super.key,
    this.onSearchTap,
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

  bool isFetching = false;

  @override
  void initState() {
    super.initState();
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
        searchMethod: widget.$searchMethod.value,
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
    final onSearchTap = widget.onSearchTap;
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
                    onSearchTap: onSearchTap,
                    onTap: () async {
                      await context.show$Sheet$(
                        (ctx) => BookDetailsPage(
                          book: BookModel.fromBook(book.book),
                          image: book.image,
                          holding: book.holding,
                          onSearchTap: onSearchTap == null
                              ? null
                              : (method, keyword) {
                                  // pop the sheet
                                  ctx.pop();
                                  onSearchTap(method, keyword);
                                },
                        ),
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
    return widget.$searchMethod >>
        (ctx, _) => SearchMethodSwitcher(
              selected: widget.$searchMethod.value,
              onSelect: (newSelection) {
                setState(() {
                  widget.$searchMethod.value = newSelection;
                  books = [];
                  currentPage = 1;
                });
                fetchNextPage();
              },
            );
  }
}

class BookCard extends StatelessWidget {
  final BookImageHolding bookImageHolding;
  final void Function()? onTap;
  final BookSearchCallback? onSearchTap;

  const BookCard(
    this.bookImageHolding, {
    super.key,
    this.onSearchTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final book = bookImageHolding.book;
    final onSearchTap = this.onSearchTap;
    final holding = bookImageHolding.holding ?? const [];
    final imgUrl = bookImageHolding.image?.resourceLink;
    // 计算总共馆藏多少书
    int copyCount = holding.isEmpty ? 0 : holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount =
        holding.isEmpty ? 0 : holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: book.author,
                  style: const TextStyle(color: Colors.blue),
                  recognizer: onSearchTap == null
                      ? null
                      : (TapGestureRecognizer()
                        ..onTap = () async {
                          onSearchTap(SearchMethod.author, book.author);
                        }),
                )
              ],
              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ),
          if (book.isbn.isNotEmpty) "${SearchMethod.isbn.l10nName()} ${book.isbn}".text(),
          "${SearchMethod.callNumber.l10nName()} ${book.callNumber}".text(),
          RichText(
              text: TextSpan(
            children: [
              TextSpan(
                style: const TextStyle(color: Colors.blue),
                text: book.publisher,
                recognizer: onSearchTap == null
                    ? null
                    : (TapGestureRecognizer()
                      ..onTap = () async {
                        onSearchTap(SearchMethod.publisher, book.publisher);
                      }),
              ),
              const TextSpan(text: " "),
              TextSpan(text: book.publishDate),
            ],
            style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
          ))
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      ),
    );
  }
}
