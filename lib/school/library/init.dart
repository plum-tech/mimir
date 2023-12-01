import 'package:sit/school/library/service/auth.dart';
import 'package:sit/school/library/storage/book.dart';
import 'package:sit/school/library/storage/borrow.dart';

import 'service/details.dart';
import 'service/book.dart';
import 'service/borrow.dart';
import 'service/holding.dart';
import 'service/holding_preview.dart';
import 'service/hot_search.dart';
import 'service/image_search.dart';
import 'storage/browse.dart';
import 'storage/search.dart';

class LibraryInit {
  static late LibraryAuthService auth;
  static late BookDetailsService bookDetailsService;
  static late HoldingInfoService holdingInfo;
  static late BookSearchService bookSearch;
  static late BookImageSearchService bookImageSearch;
  static late HoldingPreviewService holdingPreview;
  static late HotSearchService hotSearchService;
  static late LibraryBorrowService borrowService;

  static late LibrarySearchStorage searchStorage;
  static late LibraryBookStorage bookStorage;
  static late LibraryBorrowStorage borrowStorage;
  static late LibraryBrowseStorage browseStorage;

  static void init() {
    auth = const LibraryAuthService();

    bookSearch = const BookSearchService();
    bookDetailsService = const BookDetailsService();
    holdingInfo = const HoldingInfoService();
    bookImageSearch = const BookImageSearchService();
    holdingPreview = const HoldingPreviewService();
    hotSearchService = const HotSearchService();

    borrowService = const LibraryBorrowService();

    searchStorage = const LibrarySearchStorage();
    bookStorage = const LibraryBookStorage();
    borrowStorage = const LibraryBorrowStorage();
    browseStorage = const LibraryBrowseStorage();
  }
}
