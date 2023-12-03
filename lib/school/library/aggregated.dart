import 'entity/holding_preview.dart';
import 'entity/image.dart';
import 'entity/book.dart';
import 'init.dart';

class LibraryAggregated {
  /// The result isbn the same as [isbnList]
  static Future<Map<String, BookImage>> fetchBookImages({
    required List<String> isbnList,
  }) async {
    final result = <String, BookImage>{};
    final searchRequired = <String>[];
    for (final isbn in isbnList) {
      final image = LibraryInit.imageStorage.getImage(isbn);
      if (image == null) {
        searchRequired.add(isbn);
      } else {
        result[isbn] = image;
      }
    }
    if (searchRequired.isNotEmpty) {
      final isbn2Image = await LibraryInit.bookImageSearch.searchByIsbnList(searchRequired);
      for (final isbn in searchRequired) {
        final image = isbn2Image[isbn.replaceAll('-', '')];
        if (image != null) {
          result[isbn] = image;
          await LibraryInit.imageStorage.setImage(isbn, image);
        }
      }
    }
    return result;
  }

  static Future<BookImage?> fetchBookImage({required String isbn}) async {
    final result = await fetchBookImages(isbnList: [isbn]);
    return result.entries.firstOrNull?.value;
  }

  static BookImage? getCachedBookImageByIsbn(String isbn) {
    return LibraryInit.imageStorage.getImage(isbn);
  }

  /// [Book.bookId] to [HoldingPreviewItem]
  static Future<Map<String, List<HoldingPreviewItem>>> fetchBookHoldingPreviewList({
    required List<String> bookIdList,
  }) async {
    final bookId2Preview = await LibraryInit.holdingPreview.getHoldingPreviews(bookIdList);
    return bookId2Preview;
  }

  static Future<List<({Book book, List<HoldingPreviewItem> holding})>> queryHolding(
    List<Book> books,
  ) async {
    final bookIdList = books.map((e) => e.bookId).toList();
    final previews = await LibraryInit.holdingPreview.getHoldingPreviews(bookIdList);

    return books.map((book) {
      return (
        book: book,
        holding: previews[book.bookId] ?? const [],
      );
    }).toList();
  }
}
