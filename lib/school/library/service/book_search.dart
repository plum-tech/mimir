import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../entity/book.dart';
import '../constant.dart';
import '../entity/search.dart';

class BookSearchService {
  LibrarySession get session => Init.librarySession;

  const BookSearchService();

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
        'searchWay': searchMethod.internalQueryParameter,
        'rows': rows.toString(),
        'sortWay': sortMethod.internalQueryParameter,
        'sortOrder': sortOrder.internalQueryParameter,
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
