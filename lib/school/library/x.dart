import 'entity/collection_preview.dart';
import 'entity/image.dart';
import 'entity/book.dart';
import 'init.dart';

class XLibrary {
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

  /// [Book.bookId] to [BookCollectionItem]
  static Future<Map<String, List<BookCollectionItem>>> fetchBooksCollectionPreviewList({
    required List<String> bookIdList,
  }) async {
    final bookId2Preview = await LibraryInit.collectionPreviewService.getCollectionPreviews(bookIdList);
    return bookId2Preview;
  }

  static Future<List<BookCollectionItem>> fetchBookCollectionPreviewList({required String bookId}) async {
    final bookId2Previews = await fetchBooksCollectionPreviewList(bookIdList: [bookId]);
    return bookId2Previews.values.first;
  }
}
