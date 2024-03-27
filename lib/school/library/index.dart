import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/library/page/borrowing.dart';
import 'package:super_context_menu/super_context_menu.dart';

import './i18n.dart';
import 'entity/borrow.dart';
import 'init.dart';
import 'page/search.dart';
import 'utils.dart';

class LibraryAppCard extends ConsumerStatefulWidget {
  const LibraryAppCard({super.key});

  @override
  ConsumerState<LibraryAppCard> createState() => _LibraryAppCardState();
}

class _LibraryAppCardState extends ConsumerState<LibraryAppCard> {

  @override
  Widget build(BuildContext context) {
    final storage = LibraryInit.borrowStorage;
    final credentials = ref.watch(CredentialsInit.storage.$libraryCredentials);
    final borrowedBooks = ref.watch(storage.$borrowed);
    return AppCard(
      title: i18n.title.text(),
      view: borrowedBooks == null ? null : buildBorrowedBook(borrowedBooks),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await showSearch(context: context, delegate: LibrarySearchDelegate());
          },
          icon: const Icon(Icons.search),
          label: i18n.action.searchBooks.text(),
        ),
        if (credentials == null)
          OutlinedButton(
            onPressed: () async {
              await context.push("/library/login");
            },
            child: i18n.action.login.text(),
          )
        else
          OutlinedButton.icon(
            onPressed: () async {
              await context.push("/library/borrowing");
            },
            icon: const Icon(Icons.person),
            label: i18n.action.borrowing.text(),
          )
      ],
    );
  }

  Widget? buildBorrowedBook(List<BorrowedBookItem> books) {
    if (books.isEmpty) return null;
    final book = books.first;
    final card = BorrowedBookCard(
      book,
      elevated: true,
    );
    if (!supportContextMenu) return card;
    return Builder(
      builder: (ctx) => ContextMenuWidget(
        menuProvider: (MenuRequest request) {
          return Menu(
            children: [
              MenuAction(
                image: MenuImage.icon(CupertinoIcons.refresh),
                title: i18n.borrowing.renew,
                callback: () async {
                  await renewBorrowedBook(ctx, book.barcode);
                },
              ),
            ],
          );
        },
        child: card,
      ),
    );
  }
}
