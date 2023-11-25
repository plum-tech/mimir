import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../constant.dart';
import '../entity/book.dart';

class BookInfoService {
  LibrarySession get session => Init.librarySession;

  const BookInfoService();

  Future<BookInfo> query(String bookId) async {
    final response = await session.request('${LibraryConst.bookUrl}/$bookId', ReqMethod.get);
    final soup = BeautifulSoup(response.data);
    final detailItems = soup
        .find('table', id: 'bookInfoTable')!
        .findAll('tr')
        .map(
          (e) => e
              .findAll('td')
              .map(
                (e) => e.text.replaceAll(RegExp(r'\s*'), ''),
              )
              .toList(),
        )
        .where(
      (element) {
        if (element.isEmpty) {
          return false;
        }
        String e1 = element[0];

        // 过滤包含这些关键字的条目
        for (final keyword in ['分享', '相关', '随书']) {
          if (e1.contains(keyword)) return false;
        }

        return true;
      },
    ).toList();

    final rawDetails = LinkedHashMap.fromEntries(
      detailItems.sublist(1).map(
            (e) => MapEntry(
              e[0].substring(0, e[0].length - 1),
              e[1],
            ),
          ),
    );
    return createBookInfo(rawDetails);
  }

  BookInfo createBookInfo(LinkedHashMap<String, String> rawDetails) {
    final isbnAndPriceStr = rawDetails['ISBN']!;
    final isbnAndPrice = isbnAndPriceStr.split('价格：');
    final isbn = isbnAndPrice[0];
    final price = isbnAndPrice[1];

    return BookInfo(
      title: rawDetails.entries.first.value,
      isbn: isbn,
      price: price,
      rawDetail: rawDetails,
    );
  }
}
