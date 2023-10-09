import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:sit/session/library.dart';
import 'dao/book_info.dart';
import 'dao/book_search.dart';
import 'dao/holding.dart';
import 'dao/holding_preview.dart';
import 'dao/hot_search.dart';
import 'dao/image_search.dart';
import 'dao/search_history.dart';
import 'service/book_info.dart';
import 'service/book_search.dart';
import 'service/holding.dart';
import 'service/holding_preview.dart';
import 'service/hot_search.dart';
import 'service/image_search.dart';
import 'storage/search_history.dart';

class LibraryInit {
  /// 图书信息访问
  static late BookInfoDao bookInfo;

  /// 馆藏信息访问
  static late HoldingInfoDao holdingInfo;

  /// 图书
  static late BookSearchDao bookSearch;

  static late BookImageSearchDao bookImageSearch;

  static late HoldingPreviewDao holdingPreview;

  static late SearchHistoryDao librarySearchHistory;

  static late HotSearchDao hotSearchService;

  static late LibrarySession session;

  /// 初始化图书馆相关的service
  static void init({
    required Dio dio,
    required Box searchHistoryBox,
  }) {
    // 图书馆初始化

    session = LibrarySession(dio);
    bookInfo = BookInfoService(session);
    holdingInfo = HoldingInfoService(session);
    bookSearch = BookSearchService(session);
    bookImageSearch = BookImageSearchService(session);
    holdingPreview = HoldingPreviewService(session);
    hotSearchService = HotSearchService(session);

    librarySearchHistory = SearchHistoryStorage(searchHistoryBox);
  }
}
