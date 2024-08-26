import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mimir/utils/error.dart';

import '../aggregated.dart';
import '../entity/image.dart';

class AsyncBookImage extends StatefulWidget {
  final String isbn;
  final ValueChanged<bool>? onHasImageChanged;

  const AsyncBookImage({
    super.key,
    required this.isbn,
    this.onHasImageChanged,
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onHasImageChanged?.call(image != null);
    });
  }

  Future<void> fetch() async {
    try {
      final image = await LibraryAggregated.fetchBookImage(isbn: widget.isbn);
      if (!mounted) return;
      setState(() {
        this.image = image;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
    }
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
    if (image == null) return const SizedBox.shrink();
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: image.resourceUrl,
      placeholder: (context, url) => const SizedBox.shrink(),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
      errorListener: (error) {
        widget.onHasImageChanged?.call(false);
      },
    );
  }
}
