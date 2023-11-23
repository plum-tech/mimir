import 'package:flutter/material.dart';
import 'package:sit/widgets/placeholder_future_builder.dart';

import '../entity/book_info.dart';
import '../entity/book_search.dart';
import '../entity/holding_preview.dart';
import '../init.dart';
import '../utils.dart';
import 'search.dart';
import 'search_result.dart';

class BookInfoPage extends StatefulWidget {
  /// 上一层传递进来的数据
  final BookImageHolding bookImageHolding;

  const BookInfoPage(this.bookImageHolding, {super.key});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  BookInfo? info;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final info = await LibraryInit.bookInfo.query(widget.bookImageHolding.book.bookId);
    if (!context.mounted) return;
    setState(() {
      this.info = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList.list(children: [
            BookCard(
              widget.bookImageHolding,
              onAuthorTap: (String key) {
                showSearch(context: context, delegate: LibrarySearchDelegate(), query: key);
              },
            ),
            const SizedBox(height: 20),
            buildBookDetail(),
            const SizedBox(height: 20),
            buildTitle('馆藏信息'),
            buildHolding(widget.bookImageHolding.holding ?? []),
            const SizedBox(height: 20),
            buildTitle('邻近的书'),
            buildNearBooks(widget.bookImageHolding.book.bookId),
          ])
        ],
      ),
    );
  }

  Widget buildBookDetail() {
    final info = this.info;
    if (info == null) return const CircularProgressIndicator.adaptive();
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

  Widget buildHoldingItem(HoldingPreviewItem item) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('索书号：' + item.callNo),
                  Text('所在馆：' + item.currentLocation),
                ],
              ),
            ),
            Text('在馆(${item.loanableCount})/馆藏(${item.copyCount})'),
          ],
        ),
      ),
    );
  }

  /// 构造馆藏信息列表
  Widget buildHolding(List<HoldingPreviewItem> items) {
    return Column(
      children: items.map(buildHoldingItem).toList(),
    );
  }

  /// 构造标题样式的文本
  Widget buildTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  /// 构造邻近的书
  Widget buildBookItem(String bookId) {
    Future<BookImageHolding> get() async {
      final result = await LibraryInit.bookSearch.search(
        keyword: bookId,
        rows: 1,
        searchWay: SearchMethod.bookId,
      );
      final ret = await BookImageHolding.simpleQuery(
        LibraryInit.bookImageSearch,
        LibraryInit.holdingPreview,
        result.books,
      );
      return ret[0];
    }

    return PlaceholderFutureBuilder<BookImageHolding>(
      future: get(),
      builder: (ctx, data, state) {
        if (data == null) return const CircularProgressIndicator.adaptive();
        return InkWell(
          child: Card(
            child: BookCard(data),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return BookInfoPage(data);
              }),
            );
          },
        );
      },
    );
  }

  Widget buildNearBooks(String bookId) {
    return PlaceholderFutureBuilder<List<String>>(
      future: LibraryInit.holdingInfo.searchNearBookIdList(bookId),
      builder: (ctx, data, state) {
        if (data == null) return const CircularProgressIndicator.adaptive();
        return Column(
          children: data.sublist(0, 5).map((bookId) {
            return Container(
              child: buildBookItem(bookId),
            );
          }).toList(),
        );
      },
    );
  }
}
