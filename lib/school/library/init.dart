import 'package:sit/school/library/service/auth.dart';

import 'service/book_info.dart';
import 'service/book_search.dart';
import 'service/holding.dart';
import 'service/holding_preview.dart';
import 'service/hot_search.dart';
import 'service/image_search.dart';
import 'storage/search_history.dart';

class LibraryInit {
  static late LibraryAuthService auth;
  /// 图书信息访问
  static late BookInfoService bookInfo;

  /// 馆藏信息访问
  static late HoldingInfoService holdingInfo;

  /// 图书
  static late BookSearchService bookSearch;

  static late BookImageSearchService bookImageSearch;

  static late HoldingPreviewService holdingPreview;

  static late SearchHistoryStorage librarySearchHistory;

  static late HotSearchService hotSearchService;

  /// 初始化图书馆相关的service
  static void init() {
    // 图书馆初始化
    auth = const LibraryAuthService();
    bookInfo = const BookInfoService();
    holdingInfo = const HoldingInfoService();
    bookSearch = const BookSearchService();
    bookImageSearch = const BookImageSearchService();
    holdingPreview = const HoldingPreviewService();

    librarySearchHistory = const SearchHistoryStorage();
    hotSearchService = const HotSearchService();
  }
}
