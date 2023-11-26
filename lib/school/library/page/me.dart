import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/library/entity/book.dart';
import 'package:sit/school/library/init.dart';

import '../entity/borrow.dart';
import '../i18n.dart';

class LibraryMyBorrowedPage extends StatefulWidget {
  const LibraryMyBorrowedPage({super.key});

  @override
  State<LibraryMyBorrowedPage> createState() => _LibraryMyBorrowedPageState();
}

class _LibraryMyBorrowedPageState extends State<LibraryMyBorrowedPage> {
  bool isFetching = false;
  List<BorrowedBookItem>? borrowed;

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
            title: "Borrowing".text(),
            actions: [
              PlatformTextButton(
                child: "History".text(),
                onPressed: () async {
                  await context.push("/library/my-borrowing-history");
                },
              ),
            ],
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
        title: book.title.text(),
        subtitle: [
          book.author.text(),
          "${i18n.info.barcode} ${book.barcode}".text(),
          "${i18n.info.callNumber} ${book.callNumber}".text(),
          "${i18n.info.isbn} ${book.isbn}".text(),
          "${context.formatYmdText(book.borrowDate)}–${context.formatYmdText(book.expireDate)}".text(),
          Divider(color: context.colorScheme.onSurfaceVariant),
          FilledButton.icon(
            onPressed: () async {
              await LibraryInit.borrowService.renewBook(barcodeList: [book.barcode]);
            },
            icon: const Icon(Icons.autorenew),
            label: "Renew".text(),
          ),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
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
  List<BorrowedBookHistoryItem>? history;

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
          ),
          if (history != null)
            SliverList.builder(
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                return BorrowedBookHistoryCard(history[i]);
              },
            ),
        ],
      ),
    );
  }
}

class BorrowedBookHistoryCard extends StatelessWidget {
  final BorrowedBookHistoryItem book;

  const BorrowedBookHistoryCard(
    this.book, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: ListTile(
        isThreeLine: true,
        title: book.title.text(),
        subtitle: [
          book.bookId.text(),
          book.isbn.text(),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      ),
    );
  }
}
