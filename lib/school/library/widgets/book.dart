import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../aggregated.dart';
import '../entity/image.dart';

class AsyncBookImage extends StatefulWidget {
  final String isbn;

  const AsyncBookImage({
    super.key,
    required this.isbn,
  });

  @override
  State<AsyncBookImage> createState() => _AsyncBookImageState();
}

class _AsyncBookImageState extends State<AsyncBookImage> {
  late BookImage? image = LibraryAggregated.getCachedBookImageByIsbn(widget.isbn);

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final image = await LibraryAggregated.fetchBookImage(isbn: widget.isbn);
    if (!mounted) return;
    setState(() {
      this.image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Durations.long2,
      curve: Curves.fastEaseInToSlowEaseOut,
      child: buildContext(),
    );
  }

  Widget buildContext() {
    final image = this.image;
    if (image == null) return const SizedBox();
    return CachedNetworkImage(
      imageUrl: image.resourceLink,
      placeholder: (context, url) => const SizedBox(),
      errorWidget: (context, url, error) => const SizedBox(),
    );
  }
}

class BookCachedImage extends StatelessWidget {
  final String url;

  const BookCachedImage({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
