import 'dart:math';

import '../entity/book_search.dart';

class BookSearchMock {
  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchMethod searchWay = SearchMethod.title,
    SortMethod sortWay = SortMethod.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    await Future.delayed(const Duration(microseconds: 300));
    var length = 100;
    return BookSearchResult(
        length,
        Random.secure().nextDouble(),
        page,
        length ~/ rows,
        List.generate(
          length,
          (index) {
            var i = index;
            return Book('id$i', 'isbn$i', 'title$i', 'author$i', 'publisher$i', 'pubDate$i', 'callNo$i');
          },
        ));
  }
}
