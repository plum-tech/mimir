import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/library/init.dart';
import 'package:sit/utils/error.dart';

import '../entity/borrow.dart';
import '../i18n.dart';
import '../widgets/book.dart';
import 'details.dart';
import 'details.model.dart';

class LibraryMyBorrowingHistoryPage extends StatefulWidget {
  const LibraryMyBorrowingHistoryPage({super.key});

  @override
  State<LibraryMyBorrowingHistoryPage> createState() => _LibraryMyBorrowingHistoryPageState();
}

class _LibraryMyBorrowingHistoryPageState extends State<LibraryMyBorrowingHistoryPage> {
  bool isFetching = false;
  List<BookBorrowingHistoryItem>? history = LibraryInit.borrowStorage.getBorrowHistory();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      final history = await LibraryInit.borrowService.getHistoryBorrowBookList();
      await LibraryInit.borrowStorage.setBorrowHistory(history);
      if (!mounted) return;
      setState(() {
        this.history = history;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = this.history;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: i18n.history.title.text(),
            bottom: isFetching
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          if (history != null)
            if (history.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.history.noHistory,
                ),
              )
            else
              SliverList.builder(
                itemCount: history.length,
                itemBuilder: (ctx, i) {
                  return BookBorrowHistoryCard(history[i]);
                },
              ),
        ],
      ),
    );
  }
}

class BookBorrowHistoryCard extends StatelessWidget {
  final BookBorrowingHistoryItem book;

  const BookBorrowHistoryCard(
    this.book, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: AsyncBookImage(isbn: book.isbn),
        title: book.title.text(),
        subtitle: [
          book.author.text(),
          "${i18n.info.barcode} ${book.barcode}".text(),
          "${i18n.info.isbn} ${book.isbn}".text(),
          context.formatYmdText(book.processDate).text(),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
        trailing: book.operation.l10n().text(),
        onTap: () async {
          await context.show$Sheet$(
            (ctx) => BookDetailsPage(
              book: BookModel.fromBorrowHistory(book),
            ),
          );
        },
      ),
    );
  }
}
