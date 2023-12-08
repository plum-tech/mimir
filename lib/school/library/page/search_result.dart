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
import 'package:sit/utils/error.dart';

import '../entity/book.dart';
import '../entity/search.dart';
import '../init.dart';
import '../i18n.dart';
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
  final scrollController = ScrollController();
  static const sizePerPage = 30;
  BookSearchResult? lastResult;
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
    final lastResult = this.lastResult;
    if (lastResult != null && lastResult.currentPage > lastResult.totalPage) return;
    setState(() {
      isFetching = true;
    });
    try {
      final searchResult = await LibraryInit.bookSearch.search(
        keyword: widget.query,
        rows: sizePerPage,
        page: lastResult != null ? lastResult.currentPage + 1 : 0,
        searchMethod: widget.$searchMethod.value,
      );
      if (!mounted) return;
      setState(() {
        final books = this.books ??= <Book>[];
        books.addAll(searchResult.books);
        this.lastResult = searchResult;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
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
                  desc: i18n.noBooks,
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
                widget.$searchMethod.value = newSelection;
                setState(() {
                  books = null;
                  lastResult = null;
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
            "${i18n.info.callNumber} ${book.callNumber}".text(),
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
