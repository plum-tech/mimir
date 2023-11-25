import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../entity/book_search.dart';
import '../constant.dart';
import '../entity/search.dart';

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

    final bookCoverImage = e.find('img', class_: 'bookcover_img')!;
    final author = getBookInfo('a', '.author-link');
    final bookId = bookCoverImage.attributes['bookrecno']!;
    final isbn = bookCoverImage.attributes['isbn']!;
    final callNo = getBookInfo('span', '.callnosSpan');
    final publishDate = getBookInfo('div', 'div').split('出版日期:')[1].split('\n')[0].trim();

    final publisher = getBookInfo('a', '.publisher-link');
    final title = getBookInfo('a', '.title-link');
    return Book(
      bookId: bookId,
      isbn: isbn,
      title: title,
      author: author,
      publisher: publisher,
      publishDate: publishDate,
      callNo: callNo,
    );
  }

  Future<BookSearchResult> search({
    String keyword = '',
    int rows = 10,
    int page = 1,
    SearchMethod searchMethod = SearchMethod.any,
    SortMethod sortMethod = SortMethod.matchScore,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    final response = await session.request(
      LibraryConst.searchUrl,
      ReqMethod.get,
      para: {
        'q': keyword,
        'searchType': 'standard',
        'isFacet': 'true',
        'view': 'standard',
        'searchWay': _searchWayToString(searchMethod),
        'rows': rows.toString(),
        'sortWay': _sortWayToString(sortMethod),
        'sortOrder': _sortOrderToString(sortOrder),
        'hasholding': '1',
        'searchWay0': 'marc',
        'logical0': 'AND',
        'page': page.toString(),
      },
    );

    final soup = BeautifulSoup(response.data);

    final currentPage = soup.find('b', selector: '.meneame > b')?.text.trim() ?? '$page';
    final resultNumAndTime = soup
        .find(
          'div',
          selector: '#search_meta > div:nth-child(1)',
        )!
        .text;
    final resultCount =
        int.parse(RegExp(r'检索到: (\S*) 条结果').allMatches(resultNumAndTime).first.group(1)!.replaceAll(',', ''));
    final useTime = double.parse(RegExp(r'检索时间: (\S*) 秒').allMatches(resultNumAndTime).first.group(1)!);
    final totalPages = soup.find('div', class_: 'meneame')!.find('span', class_: 'disabled')!.text.trim();

    return BookSearchResult(
      resultCount: resultCount,
      useTime: useTime,
      currentPage: int.parse(currentPage),
      totalPages: int.parse(totalPages.substring(1, totalPages.length - 1).trim().replaceAll(',', '')),
      books: soup.find('table', class_: 'resultTable')!.findAll('tr').map((e) => _parseBook(e)).toList(),
    );
  }
}
