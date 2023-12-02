import 'package:sit/school/library/aggregated.dart';

import 'entity/image.dart';
import 'entity/book.dart';
import 'entity/holding_preview.dart';
import 'init.dart';

Future<List<({Book book, BookImage? image, List<HoldingPreviewItem>? holding})>> libraryAggregatedQuery(
  List<Book> books, // 图书搜索结果
) async {
  final isbnList = books.map((e) => e.isbn).toList();
  final imageResult = await LibraryAggregated.searchBookImageByIsbnList(isbnList);
  final bookIdList = books.map((e) => e.bookId).toList();
  final previews = await LibraryInit.holdingPreview.getHoldingPreviews(bookIdList);

  return books.map((book) {
    return (
      book: book,
      image: imageResult[book.isbn],
      holding: previews[book.bookId],
    );
  }).toList();
}
