import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../entity/borrow.dart';
import '../const.dart';

final _historyDateFormat = DateFormat('yyyy-MM-dd');

class LibraryBorrowService {
  LibrarySession get session => Init.librarySession;

  const LibraryBorrowService();

  Future<List<BookBorrowHistoryItem>> getHistoryBorrowBookList() async {
    final response = await session.request(
      LibraryConst.historyLoanListUrl,
      para: {
        'page': 1.toString(),
        'rows': 99999.toString(),
      },
      options: Options(
        method: "GET",
      ),
    );
    final html = BeautifulSoup(response.data);
    final table = html.find('table', id: 'contentTable');
    if (table == null) {
      return const <BookBorrowHistoryItem>[];
    }
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      return BookBorrowHistoryItem(
        bookId: columns[0].find('input')!.attributes['value']!,
        operateType: columnsText[0],
        barcode: columnsText[1],
        title: columnsText[2],
        isbn: columnsText[3],
        author: columnsText[4],
        callNumber: columnsText[5],
        location: columnsText[6],
        type: columnsText[7],
        processDate: _historyDateFormat.parse(columnsText[8]),
      );
    }).toList();
  }

  Future<List<BorrowedBookItem>> getMyBorrowBookList() async {
    final response = await session.request(
      LibraryConst.currentLoanListUrl,
      para: {
        'page': 1.toString(),
        'rows': 99999.toString(),
      },
      options: Options(
        method: "GET",
      ),
    );
    final html = BeautifulSoup(response.data);
    final table = html.find('table', id: 'contentTable');
    if (table == null) {
      return const <BorrowedBookItem>[];
    }
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      final dataFormat = DateFormat('yyyy-MM-dd');
      return BorrowedBookItem(
        bookId: columns[0].find('input')!.attributes['value']!,
        barcode: columnsText[0],
        title: columnsText[1],
        isbn: columnsText[2],
        author: columnsText[3],
        callNumber: columnsText[4],
        location: columnsText[5],
        type: columnsText[6],
        borrowDate: dataFormat.parse(columnsText[7]),
        expireDate: dataFormat.parse(columnsText[8]),
      );
    }).toList();
  }

  Future<String> renewBook({
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    await session.request(
      LibraryConst.renewList,
      options: Options(
        method: "GET",
      ),
    );
    final listRes = await session.request(
      LibraryConst.renewList,
      options: Options(
        method: "GET",
      ),
    );
    final listHtml = BeautifulSoup(listRes.data);
    final pdsToken = listHtml.find('input', attrs: {'name': 'pdsToken'})!.attributes['value'] ?? '';
    final renewRes = await session.request(
      LibraryConst.doRenewUrl,
      data: FormData.fromMap({
        'pdsToken': pdsToken,
        'barcodeList': barcodeList.join(','),
        'furl': '/opac/loan/renewList',
        'renewAll': renewAll ? 'all' : '',
      }),
      options: Options(
        method: "POST",
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    final renewHtml = BeautifulSoup(renewRes.data);
    final result = renewHtml.find('div', id: 'content')!.text;
    return result.replaceAll(RegExp(r"\s+"), "");
  }
}
