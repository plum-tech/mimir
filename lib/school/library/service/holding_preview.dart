import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../entity/holding_preview.dart';
import '../const.dart';

class HoldingPreviewService {
  LibrarySession get session => Init.librarySession;

  const HoldingPreviewService();

  Future<Map<String, List<HoldingPreviewItem>>> getHoldingPreviews(
    List<String> bookIdList,
  ) async {
    final response = await session.request(
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
    final json = response.data;
    final previewsRaw = json['previews'] as Map<String, dynamic>?;
    if (previewsRaw == null) return <String, List<HoldingPreviewItem>>{};
    final previews = previewsRaw.map((k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => HoldingPreviewItem.fromJson(e as Map<String, dynamic>)).toList()));
    return previews;
  }
}
