import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/library/init.dart';

import '../entity/borrow.dart';

class LibraryMyBorrowedPage extends StatefulWidget {
  const LibraryMyBorrowedPage({super.key});

  @override
  State<LibraryMyBorrowedPage> createState() => _LibraryMyBorrowedPageState();
}

class _LibraryMyBorrowedPageState extends State<LibraryMyBorrowedPage> {
  bool isFetching = false;
  List<BorrowBookItem>? borrowed;

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
              )
            ],
          ),
        ],
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
  List<BorrowBookHistoryItem>? history;

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: "Borrowing history".text(),
          ),
        ],
      ),
    );
  }
}
