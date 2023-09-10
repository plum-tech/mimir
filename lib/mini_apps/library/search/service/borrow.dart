import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:mimir/network/session.dart';

import '../dao/borrow.dart';
import '../entity/borrow.dart';
import 'constant.dart';

class LibraryBorrowService implements LibraryBorrowDao {
  final ISession session;

  const LibraryBorrowService(this.session);

  @override
  Future<List<HistoryBorrowBookItem>> getHistoryBorrowBookList(int page, int rows) async {
    final response = await session.request(
      Constants.historyLoanListUrl,
      ReqMethod.get,
      para: {
        'page': page.toString(),
        'rows': rows.toString(),
      },
    );
    final String html = response.data;
    final table = BeautifulSoup(html).find('table', id: 'contentTable')!;
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      return HistoryBorrowBookItem()
        ..bookId = columns[0].find('input')!.attributes['value']!
        ..operateType = columnsText[0]
        ..barcode = columnsText[1]
        ..title = columnsText[2]
        ..isbn = columnsText[3]
        ..author = columnsText[4]
        ..callNo = columnsText[5]
        ..location = columnsText[6]
        ..type = columnsText[7]
        ..processDate = DateFormat('yyyy-MM-dd').parse(columnsText[8]);
    }).toList();
  }

  @override
  Future<List<BorrowBookItem>> getMyBorrowBookList(int page, int rows) async {
    final response = await session.request(
      Constants.currentLoanListUrl,
      ReqMethod.get,
      para: {
        'page': page.toString(),
        'rows': rows.toString(),
      },
    );
    final String html = response.data;
    final table = BeautifulSoup(html).find('table', id: 'contentTable')!;
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      final dataFormat = DateFormat('yyyy-MM-dd');
      return BorrowBookItem()
        ..bookId = columns[0].find('input')!.attributes['value']!
        ..barcode = columnsText[0]
        ..title = columnsText[1]
        ..isbn = columnsText[2]
        ..author = columnsText[3]
        ..callNo = columnsText[4]
        ..location = columnsText[5]
        ..type = columnsText[6]
        ..borrowDate = dataFormat.parse(columnsText[7])
        ..expireDate = dataFormat.parse(columnsText[8]);
    }).toList();
  }

  Future<String> _doRenew({
    required String pdsToken,
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    final response = await session.request(
      Constants.doRenewUrl,
      ReqMethod.post,
      data: {
        'pdsToken': pdsToken,
        'barcodeList': barcodeList.join(','),
        'furl': '/opac/loan/renewList',
        'renewAll': renewAll ? 'all' : '',
      },
    );
    return BeautifulSoup(response.data).find('div', id: 'content')!.text;
  }

  @override
  Future<String> renewBook({
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    final response = await session.request(Constants.renewList, ReqMethod.get);
    final pdsToken = BeautifulSoup(response.data).find('input', attrs: {'name': 'pdsToken'})!.attributes['value'] ?? '';
    return await _doRenew(
      pdsToken: pdsToken,
      barcodeList: barcodeList,
      renewAll: renewAll,
    );
  }
}
