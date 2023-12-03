import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../entity/holding.dart';
import '../const.dart';

class HoldingInfoService {
  LibrarySession get session => Init.librarySession;

  const HoldingInfoService();

  Future<List<BookHolding>> queryByBookId(String bookId) async {
    final response = await session.request(
      '${LibraryConst.bookHoldingUrl}/$bookId',
      options: Options(
        method: "GET",
      ),
    );

    final rawBookHoldingInfo = BookHoldingInfo.fromJson(response.data);
    final result = rawBookHoldingInfo.holdingList.map((rawHoldingItem) {
      final bookRecordId = rawHoldingItem.bookRecordId;
      final bookId = rawHoldingItem.bookId;
      final stateTypeName = rawBookHoldingInfo.holdStateMap[rawHoldingItem.stateType.toString()]!.stateName;
      final barcode = rawHoldingItem.barcode;
      final callNo = rawHoldingItem.callNo;
      final originLibrary = rawBookHoldingInfo.libraryCodeMap[rawHoldingItem.originLibraryCode]!;
      final originLocation = rawBookHoldingInfo.locationMap[rawHoldingItem.originLocationCode]!;
      final currentLibrary = rawBookHoldingInfo.libraryCodeMap[rawHoldingItem.currentLibraryCode]!;
      final currentLocation = rawBookHoldingInfo.locationMap[rawHoldingItem.currentLocationCode]!;
      final circulateTypeName = rawBookHoldingInfo.circulateTypeMap[rawHoldingItem.circulateType]!.name;
      final circulateTypeDescription = rawBookHoldingInfo.circulateTypeMap[rawHoldingItem.circulateType]!.description;
      final registerDate = DateTime.parse(rawHoldingItem.registerDate);
      final inDate = DateTime.parse(rawHoldingItem.inDate);
      final singlePrice = rawHoldingItem.singlePrice;
      final totalPrice = rawHoldingItem.totalPrice;
      return BookHolding(
        bookRecordId: bookRecordId,
        bookId: bookId,
        stateTypeName: stateTypeName,
        barcode: barcode,
        callNumber: callNo,
        originLibrary: originLibrary,
        originLocation: originLocation,
        currentLibrary: currentLibrary,
        currentLocation: currentLocation,
        circulateTypeName: circulateTypeName,
        circulateTypeDescription: circulateTypeDescription,
        registerDate: registerDate,
        inDate: inDate,
        singlePrice: singlePrice,
        totalPrice: totalPrice,
      );
    }).toList();
    return result;
  }

  /// 搜索附近的书的id号
  Future<List<String>> searchNearBookIdList(String bookId) async {
    final response = await session.request(
      LibraryConst.virtualBookshelfUrl,
      para: {
        'bookrecno': bookId,

        // 1 表示不出现同一本书的重复书籍
        'holding': '1',
      },
      options: Options(
        method: "GET",
      ),
    );
    final soup = BeautifulSoup(response.data);
    return soup
        .findAll(
          'a',
          attrs: {'target': '_blank'},
        )
        .map(
          (e) => e.attributes['href']!,
        )
        .map((e) => e.split('book/')[1])
        .toList();
  }
}
