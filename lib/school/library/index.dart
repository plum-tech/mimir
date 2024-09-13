import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/feature/utils.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/school/library/page/borrowing.dart';
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
    final credentials = ref.watch(CredentialsInit.storage.library.$credentials);
    final borrowedBooks = ref.watch(storage.$borrowed);
    return AppCard(
      title: i18n.title.text(),
      view: borrowedBooks == null ? null : buildBorrowedBook(borrowedBooks),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await showSearch(
              useRootNavigator: true,
              context: context,
              delegate: LibrarySearchDelegate(),
            );
          },
          icon: Icon(context.icons.search),
          label: i18n.action.searchBooks.text(),
        ),
        if (can(AppFeature.libraryAccount$, ref))
          if (credentials == null)
            FilledButton.tonal(
              onPressed: () async {
                await context.push("/library/login");
              },
              child: i18n.action.login.text(),
            )
          else
            FilledButton.tonalIcon(
              onPressed: () async {
                await context.push("/library/borrowing");
              },
              icon: Icon(context.icons.person),
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
                image: MenuImage.icon(context.icons.refresh),
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
