import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../entity/collection_preview.dart';
import '../api.dart';

class LibraryCollectionPreviewService {
  LibrarySession get session => Init.librarySession;

  const LibraryCollectionPreviewService();

  Future<Map<String, List<BookCollectionItem>>> getCollectionPreviews(
    List<String> bookIdList,
  ) async {
    final response = await session.request(
      LibraryApi.bookCollectionPreviewsUrl,
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
    if (previewsRaw == null) return <String, List<BookCollectionItem>>{};
    final previews = previewsRaw.map((k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => BookCollectionItem.fromJson(e as Map<String, dynamic>)).toList()));
    return previews;
  }
}
