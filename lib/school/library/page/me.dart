import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/library/aggregated.dart';
import 'package:sit/school/library/init.dart';

import '../entity/borrow.dart';
import '../entity/image.dart';
import '../i18n.dart';
import '../widgets/book.dart';
import 'details.dart';
import 'details.model.dart';

class LibraryMyBorrowedPage extends StatefulWidget {
  const LibraryMyBorrowedPage({super.key});

  @override
  State<LibraryMyBorrowedPage> createState() => _LibraryMyBorrowedPageState();
}

class _LibraryMyBorrowedPageState extends State<LibraryMyBorrowedPage> {
  bool isFetching = false;
  List<BorrowedBookItem>? borrowed = LibraryInit.borrowStorage.getBorrowedBooks();

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
      final borrowed = await LibraryInit.borrowService.getMyBorrowBookList();
      await LibraryInit.borrowStorage.setBorrowedBooks(borrowed);
      if (!mounted) return;
      setState(() {
        this.borrowed = borrowed;
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
    final borrowed = this.borrowed;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: "Borrowed".text(),
            actions: [
              PlatformTextButton(
                child: "History".text(),
                onPressed: () async {
                  await context.push("/library/my-borrowing-history");
                },
              ),
            ],
            bottom: isFetching
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          if (borrowed != null)
            SliverList.builder(
              itemCount: borrowed.length,
              itemBuilder: (ctx, i) {
                return BorrowedBookCard(borrowed[i]);
              },
            ),
        ],
      ),
    );
  }
}

class BorrowedBookCard extends StatelessWidget {
  final BorrowedBookItem book;

  const BorrowedBookCard(
    this.book, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: ListTile(
        isThreeLine: true,
        leading: AsyncBookImage(isbn: book.isbn),
        title: book.title.text(),
        subtitle: [
          book.author.text(),
          "${i18n.info.barcode} ${book.barcode}".text(),
          "${i18n.info.isbn} ${book.isbn}".text(),
          "${context.formatYmdText(book.borrowDate)}–${context.formatYmdText(book.expireDate)}".text(),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
        onTap: () async {
          await context.show$Sheet$(
            (ctx) => BookDetailsPage(
              book: BookModel.fromBorrowed(book),
              actions: [
                PlatformTextButton(
                  onPressed: () async {
                    final result = await LibraryInit.borrowService.renewBook(barcodeList: [book.barcode]);
                    if (!context.mounted) return;
                    await context.showTip(title: "Result", ok: i18n.ok, desc: result);
                  },
                  child: "Renew".text(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class LibraryMyBorrowingHistoryPage extends StatefulWidget {
  const LibraryMyBorrowingHistoryPage({super.key});

  @override
  State<LibraryMyBorrowingHistoryPage> createState() => _LibraryMyBorrowingHistoryPageState();
}

class _LibraryMyBorrowingHistoryPageState extends State<LibraryMyBorrowingHistoryPage> {
  bool isFetching = false;
  List<BookBorrowHistoryItem>? history = LibraryInit.borrowStorage.getBorrowHistory();

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
    final history = this.history;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: "Borrowing history".text(),
            bottom: isFetching
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          if (history != null)
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
  final BookBorrowHistoryItem book;

  const BookBorrowHistoryCard(
    this.book, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: ListTile(
        leading: AsyncBookImage(isbn: book.isbn),
        title: book.title.text(),
        subtitle: [
          book.author.text(),
          "${i18n.info.barcode} ${book.barcode}".text(),
          "${i18n.info.isbn} ${book.isbn}".text(),
          context.formatYmdText(book.processDate).text(),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
        trailing: book.operateType.text(),
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
