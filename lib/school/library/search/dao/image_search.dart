import '../entity/book_image.dart';

abstract class BookImageSearchDao {
  Future<Map<String, BookImage>> searchByIsbnList(List<String> isbnList);
}
