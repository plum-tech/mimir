import '../entity/book.dart';
import '../entity/search.dart';
import 'book.dart';

class DemoBookSearchService implements BookSearchService {
  const DemoBookSearchService();

  @override
  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchMethod searchMethod = SearchMethod.any,
    SortMethod sortMethod = SortMethod.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return const BookSearchResult(
      resultCount: 2,
      useTime: 1000,
      currentPage: 1,
      totalPage: 1,
      books: [],
    );
  }
}
