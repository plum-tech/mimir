import 'package:hive/hive.dart';
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

  /// 初始化图书馆相关的service
  static void init({
    required Box searchHistoryBox,
  }) {
    // 图书馆初始化
    bookInfo = const BookInfoService();
    holdingInfo = const HoldingInfoService();
    bookSearch = const BookSearchService();
    bookImageSearch = const BookImageSearchService();
    holdingPreview = const HoldingPreviewService();
    hotSearchService = const HotSearchService();

    librarySearchHistory = SearchHistoryStorage(searchHistoryBox);
  }
}
