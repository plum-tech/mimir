import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/school/library/aggregated.dart';
import 'package:sit/school/library/page/details.model.dart';
import 'package:sit/school/library/widgets/book.dart';
import 'package:sit/utils/error.dart';

import '../entity/book.dart';
import '../entity/holding_preview.dart';
import '../entity/search.dart';
import '../init.dart';
import '../i18n.dart';
import 'search_result.dart';

class BookDetailsPage extends StatefulWidget {
  final BookModel book;
  final BookSearchCallback? onSearchTap;
  final List<Widget>? actions;

  const BookDetailsPage({
    super.key,
    required this.book,
    this.onSearchTap,
    this.actions,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late BookDetails? details = LibraryInit.bookStorage.getBookDetails(widget.book.bookId);
  bool isFetching = false;
  final $hasImage = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    if (details != null) return;
    if (!context.mounted) return;
    setState(() {
      isFetching = true;
    });
    final bookId = widget.book.bookId;
    try {
      final details = await LibraryInit.bookDetailsService.query(bookId);
      await LibraryInit.bookStorage.setBookDetails(bookId, details);
      if (!context.mounted) return;
      setState(() {
        this.details = details;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return;
    }
    if (!context.mounted) return;
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    final book = widget.book;
    final onSearchTap = widget.onSearchTap;
    final publisher = book.publisher;
    final publishDate = book.publishDate;
    return SelectionArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            $hasImage >>
                (ctx, hasImage) => TweenAnimationBuilder<double>(
                      duration: Durations.long4,
                      curve: Curves.fastEaseInToSlowEaseOut,
                      tween: Tween<double>(
                        begin: 0.0,
                        end: hasImage ? 300.0 : 0.0,
                      ),
                      builder: (context, value, _) {
                        return SliverAppBar(
                          expandedHeight: value,
                          flexibleSpace: AsyncBookImage(
                            isbn: book.isbn,
                            onHasImageChanged: (value) {
                              $hasImage.value = value;
                            },
                          ),
                          actions: widget.actions,
                          bottom: isFetching
                              ? const PreferredSize(
                                  preferredSize: Size.fromHeight(4),
                                  child: LinearProgressIndicator(),
                                )
                              : null,
                        );
                      },
                    ),
            SliverList.list(children: [
              DetailListTile(
                title: i18n.info.title,
                subtitle: book.title,
                trailing: onSearchTap == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.youtube_searched_for),
                        onPressed: () {
                          onSearchTap.call(SearchMethod.title, book.title);
                        },
                      ),
              ),
              DetailListTile(
                title: i18n.info.author,
                subtitle: book.author,
                trailing: onSearchTap == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.youtube_searched_for),
                        onPressed: () {
                          onSearchTap.call(SearchMethod.author, book.author);
                        },
                      ),
              ),
              DetailListTile(
                title: i18n.info.isbn,
                subtitle: book.isbn,
              ),
              DetailListTile(
                title: i18n.info.callNumber,
                subtitle: book.callNumber,
              ),
              if (publisher != null)
                DetailListTile(
                  title: i18n.info.publisher,
                  subtitle: publisher,
                  trailing: onSearchTap == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.youtube_searched_for),
                          onPressed: () {
                            onSearchTap.call(SearchMethod.publisher, publisher);
                          },
                        ),
                ),
              if (publishDate != null)
                DetailListTile(
                  title: i18n.info.publishDate,
                  subtitle: book.publishDate,
                ),
            ]),
            SliverList.list(children: [const Divider(), BookHoldingPreviewList(book: book)]),
            if (details != null)
              SliverList.list(children: [
                const Divider(),
                buildBookDetails(details).padAll(10),
              ]),
          ],
        ),
      ),
    );
  }

  Widget buildBookDetails(BookDetails info) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(5),
      },
      // border: TableBorder.all(color: Colors.red),
      children: info.details.entries
          .map(
            (e) => TableRow(
              children: [
                e.key.text(),
                e.value.text(),
              ],
            ),
          )
          .toList(),
    );
  }
}

class BookHoldingPreviewList extends StatefulWidget {
  final BookModel book;

  const BookHoldingPreviewList({
    super.key,
    required this.book,
  });

  @override
  State<BookHoldingPreviewList> createState() => _BookHoldingPreviewListState();
}

class _BookHoldingPreviewListState extends State<BookHoldingPreviewList> {
  List<HoldingPreviewItem>? holding;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchHoldingPreview();
  }

  Future<void> fetchHoldingPreview() async {
    if (!context.mounted) return;
    setState(() {
      isFetching = true;
    });
    final bookId = widget.book.bookId;
    try {
      final holding = await LibraryAggregated.fetchBookHoldingPreviewList(bookId: bookId);
      if (!context.mounted) return;
      setState(() {
        this.holding = holding;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return;
    }
    if (!context.mounted) return;
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final holding = this.holding;
    return [
      ListTile(
        leading: const Icon(Icons.book),
        title: "Holding".text(),
      ),
      if (isFetching)
        const CircularProgressIndicator.adaptive()
      else if (holding != null)
        ...holding.map((item) {
          return ListTile(
            title: Text('所在馆：${item.currentLocation}'),
            subtitle: item.callNumber == widget.book.callNumber ? null : '索书号：${item.callNumber}'.text(),
            trailing: Text('在馆(${item.loanableCount})/馆藏(${item.copyCount})'),
          );
        })
    ].column();
  }
}
