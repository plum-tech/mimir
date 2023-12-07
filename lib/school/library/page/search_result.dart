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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../entity/book.dart';
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
  List<Book>? books;

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
      if (!mounted) return;
      setState(() {
        final books = this.books ??= <Book>[];
        books.addAll(searchResult.books);
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
    final books = this.books;
    return Scaffold(
      body: CustomScrollView(
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
              buildGrid(books)
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

  Widget buildGrid(List<Book> books) {
    final onSearchTap = widget.onSearchTap;
    return SliverFillRemaining(
      child: MasonryGridView.extent(
        controller: scrollController,
        maxCrossAxisExtent: 280,
        itemCount: books.length,
        itemBuilder: (context, i) {
          final book = books[i];
          return BookTile(
            book: book,
            onSearchTap: onSearchTap,
            onTap: () async {
              await context.show$Sheet$(
                (ctx) => BookDetailsPage(
                  book: BookModel.fromBook(book),
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
        },
      ),
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

class BookTile extends StatelessWidget {
  final Book book;
  final void Function()? onTap;
  final BookSearchCallback? onSearchTap;

  const BookTile({
    super.key,
    this.onSearchTap,
    this.onTap,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final book = this.book;
    return FilledCard(
      clip: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: [
          AsyncBookImage(isbn: book.isbn),
          [
            book.title.text(style: context.textTheme.titleMedium),
            buildAuthor(context),
            if (book.isbn.isNotEmpty) "${SearchMethod.isbn.l10nName()} ${book.isbn}".text(),
            "${SearchMethod.callNumber.l10nName()} ${book.callNumber}".text(),
            buildPublisher(context)
          ].column(mas: MainAxisSize.min).padSymmetric(v: 2, h: 4),
        ].column(mas: MainAxisSize.min),
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
