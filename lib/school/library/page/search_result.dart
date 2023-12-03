import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/library/page/details.model.dart';
import 'package:sit/school/library/widgets/book.dart';
import 'package:sit/school/library/widgets/search.dart';

import '../aggregated.dart';
import '../entity/book.dart';
import '../entity/holding_preview.dart';
import '../entity/search.dart';
import '../init.dart';
import 'details.dart';

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
  List<({Book book, List<HoldingPreviewItem> holding})>? books;

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

      if (searchResult.currentPage > totalPage) {
        setState(() {
          isFetching = false;
        });
        return;
      }
      useTime = searchResult.useTime;
      searchResultCount = searchResult.resultCount;
      currentPage = searchResult.currentPage + 1;
      totalPage = searchResult.totalPages;

      debugPrint(searchResult.toString());
      final nextPage = await LibraryAggregated.queryHolding(
        searchResult.books,
      );
      if (!mounted) return;
      setState(() {
        final books = this.books ??= <({Book book, List<HoldingPreviewItem> holding})>[];
        books.addAll(nextPage);
        isFetching = false;
      });
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
    final books = this.books;
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: buildSearchMethodSwitcher().sized(h: 40),
          ),
          if (books != null)
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
                    final (:book, :holding) = books[i];
                    return BookCard(
                      book: book,
                      holding: holding,
                      onSearchTap: onSearchTap,
                      onTap: () async {
                        await context.show$Sheet$(
                          (ctx) => BookDetailsPage(
                            book: BookModel.fromBook(book),
                            holding: holding,
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
  final Book book;
  final List<HoldingPreviewItem>? holding;
  final void Function()? onTap;
  final BookSearchCallback? onSearchTap;

  const BookCard({
    super.key,
    this.onSearchTap,
    this.onTap,
    required this.book,
    this.holding,
  });

  @override
  Widget build(BuildContext context) {
    final book = this.book;
    final holding = this.holding ?? const [];
    // 计算总共馆藏多少书
    int copyCount = holding.isEmpty ? 0 : holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount =
        holding.isEmpty ? 0 : holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
        leading: AsyncBookImage(isbn: book.isbn),
        title: book.title.text(),
        onTap: onTap,
        subtitle: [
          buildAuthor(context),
          if (book.isbn.isNotEmpty) "${SearchMethod.isbn.l10nName()} ${book.isbn}".text(),
          "${SearchMethod.callNumber.l10nName()} ${book.callNumber}".text(),
          buildPublisher(context),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      ),
    );
  }

  Widget buildAuthor(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          buildSearchableField(
            method: SearchMethod.author,
            text: book.author,
          ),
        ],
        style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget buildPublisher(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          buildSearchableField(
            method: SearchMethod.publisher,
            text: book.publisher,
          ),
          const TextSpan(text: " "),
          TextSpan(text: book.publishDate),
        ],
        style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
    );
  }

  TextSpan buildSearchableField({
    required SearchMethod method,
    required String text,
  }) {
    final onSearchTap = this.onSearchTap;
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.blue),
      recognizer: onSearchTap == null
          ? null
          : (TapGestureRecognizer()
            ..onTap = () async {
              onSearchTap(method, text);
            }),
    );
  }
}
