import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../dao/holding_preview.dart';
import '../entity/holding_preview.dart';
import 'constant.dart';

class HoldingPreviewService implements HoldingPreviewDao {
  LibrarySession get session => Init.librarySession;

  const HoldingPreviewService();

  @override
  Future<HoldingPreviews> getHoldingPreviews(List<String> bookIdList) async {
    var response = await session.request(
      Constants.bookHoldingPreviewsUrl,
      ReqMethod.get,
      para: {
        'bookrecnos': bookIdList.join(','),
        'curLibcodes': '',
        'return_fmt': 'json',
      },
    );

    return HoldingPreviews.fromJson(response.data);
  }
}
