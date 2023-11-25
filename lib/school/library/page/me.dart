import 'package:flutter/material.dart';
import 'package:sit/school/library/init.dart';

class LibraryMyBorrowingPage extends StatefulWidget {
  const LibraryMyBorrowingPage({super.key});

  @override
  State<LibraryMyBorrowingPage> createState() => _LibraryMyBorrowingPageState();
}

class _LibraryMyBorrowingPageState extends State<LibraryMyBorrowingPage> {
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final res1 = await LibraryInit.borrowService.getMyBorrowBookList(1, 9999);
    final res2 = await LibraryInit.borrowService.getHistoryBorrowBookList(1, 9999);
    print(res1);
    print(res2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(),
        ],
      ),
    );
  }
}
