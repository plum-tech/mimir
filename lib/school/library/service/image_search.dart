import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../entity/image.dart';
import '../const.dart';

/// 本类提供了一系列，通过查询图书图片的方法，返回结果类型为字典，以ISBN为键
class BookImageSearchService {
  LibrarySession get session => Init.librarySession;

  Dio get dio => Init.dio;

  const BookImageSearchService();

  /// The result isbn doesn't have hyphen `-`
  Future<Map<String, BookImage>> searchByIsbnList(List<String> isbnList) async {
    final response = await dio.request(
      LibraryConst.bookImageInfoUrl,
      queryParameters: {
        'glc': 'U1SH021060',
        'cmdACT': 'getImages',
        'type': '0',
        'isbns': isbnList.join(','),
      },
      options: Options(
        responseType: ResponseType.plain,
        method: "GET",
      ),
    );
    var resStr = (response.data as String).trim();
    resStr = resStr.substring(1, resStr.length - 1);
    final result = <String, BookImage>{};
    final resultRaw = jsonDecode(resStr)['result'] as List<dynamic>;
    final images = resultRaw.map((e) => BookImage.fromJson(e));
    for (final image in images) {
      result[image.isbn] = image;
    }
    return result;
  }
}
