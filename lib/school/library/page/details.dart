import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/list_tile.dart';

import '../entity/book.dart';
import '../entity/search.dart';
import '../init.dart';
import '../utils.dart';
import 'search_result.dart';

class BookDetailsPage extends StatefulWidget {
  final BookImageHolding bookImageHolding;
  final BookSearchCallback? onSearchTap;

  const BookDetailsPage(
    this.bookImageHolding, {
    super.key,
    this.onSearchTap,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  BookInfo? info;
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
      final info = await LibraryInit.bookInfo.query(widget.bookImageHolding.book.bookId);
      if (!context.mounted) return;
      setState(() {
        this.info = info;
        isFetching = false;
      });
    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stacktrace);
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
    final book = widget.bookImageHolding.book;
    final imgUrl = widget.bookImageHolding.image?.resourceLink;
    final holding = widget.bookImageHolding.holding;
    return SelectionArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: imgUrl == null ? null : 300.0,
              flexibleSpace: imgUrl == null
                  ? null
                  : CachedNetworkImage(
                      imageUrl: imgUrl,
                      placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fitHeight,
                    ),
              bottom: isFetching
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    )
                  : null,
            ),
            SliverList.list(children: [
              DetailListTile(
                title: "Title",
                subtitle: book.title,
                trailing: IconButton(
                  icon: const Icon(Icons.youtube_searched_for),
                  onPressed: widget.onSearchTap == null
                      ? null
                      : () {
                          widget.onSearchTap?.call(SearchMethod.title, book.title);
                        },
                ),
              ),
              DetailListTile(
                title: "Author",
                subtitle: book.author,
                trailing: IconButton(
                  icon: const Icon(Icons.youtube_searched_for),
                  onPressed: widget.onSearchTap == null
                      ? null
                      : () {
                          widget.onSearchTap?.call(SearchMethod.author, book.author);
                        },
                ),
              ),
              DetailListTile(
                title: "ISBN",
                subtitle: book.isbn,
              ),
              DetailListTile(
                title: "Call No.",
                subtitle: book.callNo,
              ),
              DetailListTile(
                title: "Publisher",
                subtitle: book.publisher,
                trailing: IconButton(
                  icon: const Icon(Icons.youtube_searched_for),
                  onPressed: widget.onSearchTap == null
                      ? null
                      : () {
                          widget.onSearchTap?.call(SearchMethod.publisher, book.publisher);
                        },
                ),
              ),
              DetailListTile(
                title: "Publish date",
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
                      subtitle: item.callNo == book.callNo ? null : '索书号：${item.callNo}'.text(),
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

  Widget buildBookDetails(BookInfo info) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(5),
      },
      // border: TableBorder.all(color: Colors.red),
      children: info.rawDetail.entries
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

class NearBooksGroup extends StatefulWidget {
  final int maxSize;
  final String bookId;

  const NearBooksGroup({
    super.key,
    required this.bookId,
    this.maxSize = 5,
  });

  @override
  State<NearBooksGroup> createState() => _NearBooksGroupState();
}

class _NearBooksGroupState extends State<NearBooksGroup> {
  List<String>? nearBookIdList;

  @override
  void initState() {
    super.initState();
    fetchNearBooks();
  }

  Future<void> fetchNearBooks() async {
    final nearBookIdList = await LibraryInit.holdingInfo.searchNearBookIdList(widget.bookId);
    if (!context.mounted) return;
    setState(() {
      this.nearBookIdList = nearBookIdList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearBookIdList = this.nearBookIdList;
    if (nearBookIdList == null) return const CircularProgressIndicator.adaptive();
    return Column(
      children: nearBookIdList.sublist(0, widget.maxSize).map((bookId) {
        return AsyncBookItem(bookId: bookId);
      }).toList(),
    );
  }
}

class AsyncBookItem extends StatefulWidget {
  final String bookId;

  const AsyncBookItem({super.key, required this.bookId});

  @override
  State<AsyncBookItem> createState() => _AsyncBookItemState();
}

class _AsyncBookItemState extends State<AsyncBookItem> {
  BookImageHolding? holding;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final result = await LibraryInit.bookSearch.search(
      keyword: widget.bookId,
      rows: 1,
      searchMethod: SearchMethod.bookId,
    );
    final ret = await BookImageHolding.simpleQuery(
      result.books,
    );
    if (!context.mounted) return;
    setState(() {
      holding = ret[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final holding = this.holding;
    if (holding == null) return const CircularProgressIndicator.adaptive();
    return BookCard(
      holding,
      onTap: () async {
        await context.show$Sheet$((ctx) => BookDetailsPage(holding));
      },
    );
  }
}
