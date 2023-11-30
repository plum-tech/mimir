import 'package:sit/school/library/service/auth.dart';

import 'service/details.dart';
import 'service/book.dart';
import 'service/borrow.dart';
import 'service/holding.dart';
import 'service/holding_preview.dart';
import 'service/hot_search.dart';
import 'service/image_search.dart';
import 'storage/search.dart';

class LibraryInit {
  static late LibraryAuthService auth;

  /// 图书信息访问
  static late BookDetailsService bookDetailsService;

  /// 馆藏信息访问
  static late HoldingInfoService holdingInfo;

  /// 图书
  static late BookSearchService bookSearch;

  static late BookImageSearchService bookImageSearch;

  static late HoldingPreviewService holdingPreview;

  static late LibrarySearchStorage searchHistoryStorage;

  static late HotSearchService hotSearchService;
  static late LibraryBorrowService borrowService;

  /// 初始化图书馆相关的service
  static void init() {
    // 图书馆初始化
    auth = const LibraryAuthService();
    bookDetailsService = const BookDetailsService();
    holdingInfo = const HoldingInfoService();
    bookSearch = const BookSearchService();
    bookImageSearch = const BookImageSearchService();
    holdingPreview = const HoldingPreviewService();

    searchHistoryStorage = const LibrarySearchStorage();
    hotSearchService = const HotSearchService();
    borrowService = const LibraryBorrowService();
  }
}
