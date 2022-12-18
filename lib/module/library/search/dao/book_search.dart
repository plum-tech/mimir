import '../entity/book_search.dart';

abstract class BookSearchDao {
  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchWay searchWay = SearchWay.title,
    SortWay sortWay = SortWay.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  });
}
