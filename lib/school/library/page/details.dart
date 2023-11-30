import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/school/library/page/details.model.dart';
import 'package:sit/widgets/image.dart';

import '../entity/book.dart';
import '../entity/image.dart';
import '../entity/holding_preview.dart';
import '../entity/search.dart';
import '../init.dart';
import '../i18n.dart';
import 'search_result.dart';

class BookDetailsPage extends StatefulWidget {
  final BookModel book;
  final BookImage? image;
  final List<HoldingPreviewItem>? holding;
  final BookSearchCallback? onSearchTap;
  final List<Widget>? actions;

  const BookDetailsPage({
    super.key,
    required this.book,
    this.image,
    this.holding,
    this.onSearchTap,
    this.actions,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  BookDetails? info;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    if (!context.mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      final info = await LibraryInit.bookDetailsService.query(widget.book.bookId);
      if (!context.mounted) return;
      setState(() {
        this.info = info;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      return;
    }
    if (!context.mounted) return;
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = this.info;
    final book = widget.book;
    final imgUrl = widget.image?.resourceLink;
    // FIXME: always null
    final holding = widget.holding;
    final onSearchTap = widget.onSearchTap;
    final publisher = book.publisher;
    final publishDate = book.publishDate;
    return SelectionArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: imgUrl == null ? null : 300.0,
              flexibleSpace: imgUrl == null ? null : CachedNetworkImageView(imageUrl: imgUrl),
              actions: widget.actions,
              bottom: isFetching
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    )
                  : null,
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
            if (holding != null)
              const SliverToBoxAdapter(
                child: Divider(),
              ),
            if (holding != null)
              SliverList.builder(
                  itemCount: holding.length,
                  itemBuilder: (ctx, i) {
                    final item = holding[i];
                    return ListTile(
                      title: Text('所在馆：${item.currentLocation}'),
                      subtitle: item.callNumber == book.callNumber ? null : '索书号：${item.callNumber}'.text(),
                      trailing: Text('在馆(${item.loanableCount})/馆藏(${item.copyCount})'),
                    );
                  }),
            if (info != null)
              SliverList.list(children: [
                const Divider(),
                buildBookDetails(info).padAll(10),
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
