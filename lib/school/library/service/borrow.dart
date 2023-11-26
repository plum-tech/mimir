import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../entity/borrow.dart';
import '../const.dart';

final _historyDateFormat = DateFormat('yyyy-MM-dd');

class LibraryBorrowService {
  LibrarySession get session =>Init.librarySession;
  const LibraryBorrowService();

  Future<List<BorrowedBookHistoryItem>> getHistoryBorrowBookList() async {
    final response = await session.request(
      LibraryConst.historyLoanListUrl,
      ReqMethod.get,
      para: {
        'page': 1.toString(),
        'rows': 99999.toString(),
      },
    );
    final html = BeautifulSoup(response.data);
    final table = html.find('table', id: 'contentTable')!;
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      return BorrowedBookHistoryItem(
        bookId: columns[0].find('input')!.attributes['value']!,
        operateType: columnsText[0],
        barcode: columnsText[1],
        title: columnsText[2],
        isbn: columnsText[3],
        author: columnsText[4],
        callNo: columnsText[5],
        location: columnsText[6],
        type: columnsText[7],
        processDate: _historyDateFormat.parse(columnsText[8]),
      );
    }).toList();
  }

  Future<List<BorrowedBookItem>> getMyBorrowBookList() async {
    final response = await session.request(
      LibraryConst.currentLoanListUrl,
      ReqMethod.get,
      para: {
        'page': 1.toString(),
        'rows': 99999.toString(),
      },
    );
    final html = BeautifulSoup(response.data);
    final table = html.find('table', id: 'contentTable')!;
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
        callNo: columnsText[4],
        location: columnsText[5],
        type: columnsText[6],
        borrowDate: dataFormat.parse(columnsText[7]),
        expireDate: dataFormat.parse(columnsText[8]),
      );
    }).toList();
  }

  Future<String> _doRenew({
    required String pdsToken,
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    final response = await session.request(
      LibraryConst.doRenewUrl,
      ReqMethod.post,
      data: {
        'pdsToken': pdsToken,
        'barcodeList': barcodeList.join(','),
        'furl': '/opac/loan/renewList',
        'renewAll': renewAll ? 'all' : '',
      },
    );
    final html = BeautifulSoup(response.data);
    return html.find('div', id: 'content')!.text;
  }

  Future<String> renewBook({
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    final response = await session.request(LibraryConst.renewList, ReqMethod.get);
    final html = BeautifulSoup(response.data);
    final pdsToken = html.find('input', attrs: {'name': 'pdsToken'})!.attributes['value'] ?? '';
    return await _doRenew(
      pdsToken: pdsToken,
      barcodeList: barcodeList,
      renewAll: renewAll,
    );
  }
}
