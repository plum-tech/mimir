import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../entity/holding_preview.dart';
import '../const.dart';

class HoldingPreviewService {
  LibrarySession get session => Init.librarySession;

  const HoldingPreviewService();

  Future<HoldingPreviews> getHoldingPreviews(List<String> bookIdList) async {
    var response = await session.request(
      LibraryConst.bookHoldingPreviewsUrl,
      para: {
        'bookrecnos': bookIdList.join(','),
        'curLibcodes': '',
        'return_fmt': 'json',
      },
      options: Options(
        method: "GET",
      ),
    );

    return HoldingPreviews.fromJson(response.data);
  }
}
