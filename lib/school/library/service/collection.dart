import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:mimir/init.dart';

import 'package:mimir/session/library.dart';

import '../entity/collection.dart';
import '../api.dart';

class LibraryCollectionInfoService {
  LibrarySession get session => Init.librarySession;

  const LibraryCollectionInfoService();

  Future<List<BookCollection>> queryByBookId(String bookId) async {
    final response = await session.request(
      '${LibraryApi.bookCollectionUrl}/$bookId',
      options: Options(
        method: "GET",
      ),
    );

    final raw = BookCollectionInfo.fromJson(response.data);
    final result = raw.holdingList.map((rawHoldingItem) {
      final bookRecordId = rawHoldingItem.bookRecordId;
      final bookId = rawHoldingItem.bookId;
      final stateTypeName = raw.holdStateMap[rawHoldingItem.stateType.toString()]!.stateName;
      final barcode = rawHoldingItem.barcode;
      final callNo = rawHoldingItem.callNumber;
      final originLibrary = raw.libraryCodeMap[rawHoldingItem.originLibraryCode]!;
      final originLocation = raw.locationMap[rawHoldingItem.originLocationCode]!;
      final currentLibrary = raw.libraryCodeMap[rawHoldingItem.currentLibraryCode]!;
      final currentLocation = raw.locationMap[rawHoldingItem.currentLocationCode]!;
      final circulateTypeName = raw.circulateTypeMap[rawHoldingItem.circulateType]!.name;
      final circulateTypeDescription = raw.circulateTypeMap[rawHoldingItem.circulateType]!.description;
      final registerDate = DateTime.parse(rawHoldingItem.registerDate);
      final inDate = DateTime.parse(rawHoldingItem.inDate);
      final singlePrice = rawHoldingItem.singlePrice;
      final totalPrice = rawHoldingItem.totalPrice;
      return BookCollection(
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
      LibraryApi.virtualBookshelfUrl,
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
