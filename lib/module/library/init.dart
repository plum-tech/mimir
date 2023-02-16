import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'search/entity/search_history.dart';
import 'search/init.dart';

class LibraryInit {
  static Future<void> init({
    required Dio dio,
    required Box<LibrarySearchHistoryItem> searchHistoryBox,
  }) async {
    await LibrarySearchInit.init(dio: dio, searchHistoryBox: searchHistoryBox);
  }
}
