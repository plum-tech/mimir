import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'search/entity/search_history.dart';
import 'search/init.dart';

class LibraryInit {
  static void init({
    required Dio dio,
    required Box<LibrarySearchHistoryItem> searchHistoryBox,
  }) async {
    LibrarySearchInit.init(dio: dio, searchHistoryBox: searchHistoryBox);
  }
}
