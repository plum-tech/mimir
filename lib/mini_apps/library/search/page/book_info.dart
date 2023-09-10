import 'package:flutter/material.dart';
import 'package:mimir/widgets/placeholder_future_builder.dart';

import '../entity/book_info.dart';
import '../entity/book_search.dart';
import '../entity/holding_preview.dart';
import '../init.dart';
import '../widgets/search_result_item.dart';
import '../utils.dart';
import 'search_delegate.dart';

class BookInfoPage extends StatefulWidget {
  /// 上一层传递进来的数据
  final BookImageHolding bookImageHolding;

  const BookInfoPage(this.bookImageHolding, {Key? key}) : super(key: key);

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  Widget buildBookDetail() {
    final bookId = widget.bookImageHolding.book.bookId;
    return PlaceholderFutureBuilder<BookInfo>(
      future: LibrarySearchInit.bookInfo.query(bookId),
      builder: (ctx, data, state) {
        if (data == null) return const CircularProgressIndicator();
        return Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(5),
          },
          // border: TableBorder.all(color: Colors.red),
          children: data.rawDetail.entries
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
      },
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
      final result = await LibrarySearchInit.bookSearch.search(
        keyword: bookId,
        rows: 1,
        searchWay: SearchWay.ctrlNo,
      );
      final ret = await BookImageHolding.simpleQuery(
        LibrarySearchInit.bookImageSearch,
        LibrarySearchInit.holdingPreview,
        result.books,
      );
      return ret[0];
    }

    return PlaceholderFutureBuilder<BookImageHolding>(
      future: get(),
      builder: (ctx, data, state) {
        if (data == null) return const CircularProgressIndicator();
        return InkWell(
          child: Card(
            child: BookItemWidget(data),
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
      future: LibrarySearchInit.holdingInfo.searchNearBookIdList(bookId),
      builder: (ctx, data, state) {
        if (data == null) return const CircularProgressIndicator();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书详情'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BookItemWidget(
              widget.bookImageHolding,
              onAuthorTap: (String key) {
                showSearch(context: context, delegate: SearchBarDelegate(), query: key);
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
          ]),
        ),
      ),
    );
  }
}
