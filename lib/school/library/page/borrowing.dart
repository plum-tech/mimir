import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/school/library/init.dart';
import 'package:mimir/school/library/utils.dart';
import 'package:mimir/utils/error.dart';

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
  bool fetching = false;
  List<BorrowedBookItem>? borrowed = LibraryInit.borrowStorage.getBorrowedBooks();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    if (!mounted) return;
    setState(() {
      fetching = true;
    });
    try {
      final borrowed = await LibraryInit.borrowService.getMyBorrowBookList();
      await LibraryInit.borrowStorage.setBorrowedBooks(borrowed);
      if (!mounted) return;
      setState(() {
        this.borrowed = borrowed;
        fetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        fetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borrowed = this.borrowed;
    return Scaffold(
      floatingActionButton: !fetching ? null : const CircularProgressIndicator.adaptive(),
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
          ),
          if (borrowed != null)
            if (borrowed.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.borrowing.noBorrowing,
                ),
              )
            else
              SliverList.builder(
                itemCount: borrowed.length,
                itemBuilder: (ctx, i) {
                  return BorrowedBookCard(
                    borrowed[i],
                    elevated: false,
                  );
                },
              ),
        ],
      ),
    );
  }
}

class BorrowedBookCard extends StatelessWidget {
  final BorrowedBookItem book;
  final bool elevated;

  const BorrowedBookCard(
    this.book, {
    super.key,
    required this.elevated,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AsyncBookImage(isbn: book.isbn),
      title: book.title.text(),
      subtitle: [
        book.author.text(),
        "${i18n.info.barcode} ${book.barcode}".text(),
        "${i18n.info.isbn} ${book.isbn}".text(),
        "${context.formatYmdText(book.borrowDate)}–${context.formatYmdText(book.expireDate)}".text(),
      ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      onTap: () async {
        await context.showSheet(
          (ctx) => BookDetailsPage(
            book: BookModel.fromBorrowed(book),
            actions: [
              PlatformTextButton(
                onPressed: () async {
                  await renewBorrowedBook(context, book.barcode);
                },
                child: i18n.borrowing.renew.text(),
              )
            ],
          ),
        );
      },
    ).inAnyCard(clip: Clip.hardEdge, type: elevated ? CardVariant.elevated : CardVariant.filled);
  }
}
