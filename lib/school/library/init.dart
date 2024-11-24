import 'package:mimir/school/library/service/auth.dart';
import 'package:mimir/school/library/storage/book.dart';
import 'package:mimir/school/library/storage/borrow.dart';

import 'service/details.dart';
import 'service/book.dart';
import 'service/borrow.dart';
import 'service/collection.dart';
import 'service/collection_preview.dart';
import 'service/trends.dart';
import 'service/image_search.dart';
import 'storage/browse.dart';
import 'storage/image.dart';
import 'storage/search.dart';

class LibraryInit {
  static late LibraryAuthService auth;
  static late BookDetailsService bookDetailsService;
  static late LibraryCollectionInfoService collectionInfoService;
  static late BookSearchService bookSearch;
  static late BookImageSearchService bookImageSearch;
  static late LibraryCollectionPreviewService collectionPreviewService;
  static late LibraryTrendsService hotSearchService;
  static late LibraryBorrowService borrowService;

  static late LibrarySearchStorage searchStorage;
  static late LibraryBookStorage bookStorage;
  static late LibraryBorrowStorage borrowStorage;
  static late LibraryImageStorage imageStorage;

  static late LibraryBrowseStorage browseStorage;

  static void init() {
    auth = const LibraryAuthService();

    bookSearch =const BookSearchService();
    bookDetailsService = const BookDetailsService();
    collectionInfoService = const LibraryCollectionInfoService();
    bookImageSearch = const BookImageSearchService();
    collectionPreviewService = const LibraryCollectionPreviewService();
    hotSearchService = const LibraryTrendsService();
    borrowService = const LibraryBorrowService();
  }

  static void initStorage() {
    searchStorage = const LibrarySearchStorage();
    bookStorage = const LibraryBookStorage();
    borrowStorage = LibraryBorrowStorage();
    imageStorage = const LibraryImageStorage();

    browseStorage = const LibraryBrowseStorage();
  }
}
