import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../entity/book_search.dart';
import 'constant.dart';

class BookSearchService {
  LibrarySession get session => Init.librarySession;

  const BookSearchService();

  static String _searchWayToString(SearchMethod sw) {
    return {
      SearchMethod.any: '',
      SearchMethod.title: 'title',
      SearchMethod.primaryTitle: 'title200a',
      SearchMethod.isbn: 'isbn',
      SearchMethod.author: 'author',
      SearchMethod.subject: 'subject',
      SearchMethod.$class: 'class',
      SearchMethod.bookId: 'ctrlno',
      SearchMethod.orderNumber: 'orderno',
      SearchMethod.publisher: 'publisher',
      SearchMethod.callNumber: 'callno',
    }[sw]!;
  }

  static String _sortWayToString(SortMethod sw) {
    return {
      SortMethod.matchScore: 'score',
      SortMethod.publishDate: 'pubdate_sort',
      SortMethod.subject: 'subject_sort',
      SortMethod.title: 'title_sort',
      SortMethod.author: 'author_sort',
      SortMethod.callNo: 'callno_sort',
      SortMethod.pinyin: 'pinyin_sort',
      SortMethod.loanCount: 'loannum_sort',
      SortMethod.renewCount: 'renew_sort',
      SortMethod.titleWeight: 'title200Weight',
      SortMethod.titleProperWeight: 'title200aWeight',
      SortMethod.volume: 'title200h',
    }[sw]!;
  }

  static String _sortOrderToString(SortOrder sw) {
    return {
      SortOrder.asc: 'asc',
      SortOrder.desc: 'desc',
    }[sw]!;
  }

  static Book _parseBook(Bs4Element e) {
    // 获得图书信息
    String getBookInfo(String name, String selector) {
      return e.find(name, selector: selector)!.text.trim();
    }

    var bookCoverImage = e.find('img', class_: 'bookcover_img')!;
    var author = getBookInfo('a', '.author-link');
    var bookId = bookCoverImage.attributes['bookrecno']!;
    var isbn = bookCoverImage.attributes['isbn']!;
    var callNo = getBookInfo('span', '.callnosSpan');
    var publishDate = getBookInfo('div', 'div').split('出版日期:')[1].split('\n')[0].trim();

    var publisher = getBookInfo('a', '.publisher-link');
    var title = getBookInfo('a', '.title-link');
    return Book(bookId, isbn, title, author, publisher, publishDate, callNo);
  }

  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchMethod searchWay = SearchMethod.any,
    SortMethod sortWay = SortMethod.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    var response = await session.request(
      Constants.searchUrl,
      ReqMethod.get,
      para: {
        'q': keyword,
        'searchType': 'standard',
        'isFacet': 'true',
        'view': 'standard',
        'searchWay': _searchWayToString(searchWay),
        'rows': rows.toString(),
        'sortWay': _sortWayToString(sortWay),
        'sortOrder': _sortOrderToString(sortOrder),
        'hasholding': '1',
        'searchWay0': 'marc',
        'logical0': 'AND',
        'page': page.toString(),
      },
    );

    final soup = BeautifulSoup(response.data);

    var currentPage = soup.find('b', selector: '.meneame > b')?.text.trim() ?? '$page';
    var resultNumAndTime = soup
        .find(
          'div',
          selector: '#search_meta > div:nth-child(1)',
        )!
        .text;
    var resultCount =
        int.parse(RegExp(r'检索到: (\S*) 条结果').allMatches(resultNumAndTime).first.group(1)!.replaceAll(',', ''));
    var useTime = double.parse(RegExp(r'检索时间: (\S*) 秒').allMatches(resultNumAndTime).first.group(1)!);
    var totalPages = soup.find('div', class_: 'meneame')!.find('span', class_: 'disabled')!.text.trim();

    return BookSearchResult(
        resultCount,
        useTime,
        int.parse(currentPage),
        int.parse(totalPages.substring(1, totalPages.length - 1).trim().replaceAll(',', '')),
        soup.find('table', class_: 'resultTable')!.findAll('tr').map((e) => _parseBook(e)).toList());
  }
}
