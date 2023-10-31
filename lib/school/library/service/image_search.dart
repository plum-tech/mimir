import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../entity/book_image.dart';
import 'constant.dart';

/// 本类提供了一系列，通过查询图书图片的方法，返回结果类型为字典，以ISBN为键
class BookImageSearchService {
  LibrarySession get session => Init.librarySession;

  const BookImageSearchService();

  Future<Map<String, BookImage>> searchByIsbnList(List<String> isbnList) async {
    return await searchByIsbnStr(isbnList.join(','));
  }

  Future<Map<String, BookImage>> searchByIsbnStr(String isbnStr) async {
    var response = await session.request(
      Constants.bookImageInfoUrl,
      ReqMethod.get,
      para: {
        'glc': 'U1SH021060',
        'cmdACT': 'getImages',
        'type': '0',
        'isbns': isbnStr,
      },
      options: SessionOptions(responseType: ResponseType.plain),
    );
    var responseStr = (response.data as String).trim();
    responseStr = responseStr.substring(1, responseStr.length - 1);
    // Log.info(responseStr);
    var result = <String, BookImage>{};
    (jsonDecode(responseStr)['result'] as List<dynamic>).map((e) => BookImage.fromJson(e)).forEach(
      (e) {
        result[e.isbn] = e;
      },
    );
    return result;
  }
}
