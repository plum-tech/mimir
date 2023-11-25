import 'package:flutter/material.dart';

class LibraryMyBorrowingPage extends StatefulWidget {
  const LibraryMyBorrowingPage({super.key});

  @override
  State<LibraryMyBorrowingPage> createState() => _LibraryMyBorrowingPageState();
}

class _LibraryMyBorrowingPageState extends State<LibraryMyBorrowingPage> {
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
