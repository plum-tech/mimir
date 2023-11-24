import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';

import '../entity/book_info.dart';
import '../entity/book_search.dart';
import '../entity/holding_preview.dart';
import '../init.dart';
import '../utils.dart';
import 'search_result.dart';

class BookInfoPage extends StatefulWidget {
  final BookImageHolding bookImageHolding;

  const BookInfoPage(this.bookImageHolding, {super.key});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
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
    return SelectionArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 300.0,
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
              ListTile(
                title: "Title".text(),
                subtitle: book.title.text(),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: "Author".text(),
                subtitle: book.author.text(),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: "ISBN".text(),
                subtitle: book.isbn.text(),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: "Call No.".text(),
                subtitle: book.callNo.text(),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: "Publisher".text(),
                subtitle: book.publisher.text(),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: "Publish date".text(),
                subtitle: book.publishDate.text(),
                visualDensity: VisualDensity.compact,
              ),
            ]),
            if (info != null)
            SliverList.list(children: [
              const Divider(),
               buildBookDetails(info).padAll(10),
            ]),
            SliverList.list(children: [
              const Divider(),
              buildHolding(widget.bookImageHolding.holding ?? []),
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
                Text(e.key, style: Theme.of(context).textTheme.titleSmall),
                SelectableText(e.value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          )
          .toList(),
    );
  }
  /// 构造馆藏信息列表
  Widget buildHolding(List<HoldingPreviewItem> items) {
    return Column(
      children: items.map((item) {
        return FilledCard(
          child: ListTile(
            title: Text('所在馆：${item.currentLocation}'),
            subtitle: Text('索书号：${item.callNo}'),
            trailing: Text('在馆(${item.loanableCount})/馆藏(${item.copyCount})'),
          ),
        );
      }).toList(),
    );
  }
}

class BookHoldingCard extends StatelessWidget {
  const BookHoldingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
      searchWay: SearchMethod.bookId,
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
        await context.show$Sheet$((ctx) => BookInfoPage(holding));
      },
    );
  }
}
