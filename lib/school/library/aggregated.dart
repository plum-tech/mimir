import 'entity/image.dart';
import 'init.dart';

class LibraryAggregated {
  /// The result isbn the same as [isbnList]
  static Future<Map<String, BookImage>> searchBookImagesByIsbnList(
    List<String> isbnList,
  ) async {
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

  static Future<BookImage?> fetchBookImageByIsbn(String isbn) async {
    final result = await searchBookImagesByIsbnList([isbn]);
    return result.entries.firstOrNull?.value;
  }

  static BookImage? getCachedBookImageByIsbn(String isbn) {
    return LibraryInit.imageStorage.getImage(isbn);
  }
}
