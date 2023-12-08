import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/library/init.dart';
import 'package:sit/utils/error.dart';

import '../entity/borrow.dart';
import '../i18n.dart';
import '../widgets/book.dart';
import 'details.dart';
import 'details.model.dart';

class LibraryBorrowingPage extends StatefulWidget {
  const LibraryBorrowingPage({super.key});

  @override
  State<LibraryBorrowingPage> createState() => _LibraryBorrowingPageState();
}

class _LibraryBorrowingPageState extends State<LibraryBorrowingPage> {
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
      debugPrintError(error, stackTrace);
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
            title: i18n.borrowing.title.text(),
            actions: [
              PlatformTextButton(
                child: i18n.borrowing.history.text(),
                onPressed: () async {
                  await context.push("/library/borrowing-history");
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
                    await renew(context);
                  },
                  child: i18n.borrowing.renew.text(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> renew(BuildContext context) async {
    try {
      final result = await LibraryInit.borrowService.renewBook(barcodeList: [book.barcode]);
      if (!context.mounted) return;
      await context.showTip(title: i18n.borrowing.renew, ok: i18n.ok, desc: result);
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
    }
  }
}

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
      debugPrintError(error, stackTrace);
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
