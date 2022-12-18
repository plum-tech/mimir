import '../../using.dart';
import '../dao/holding_preview.dart';
import '../entity/holding_preview.dart';
import 'constant.dart';

class HoldingPreviewService implements HoldingPreviewDao {
  final ISession session;

  const HoldingPreviewService(this.session);

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
