import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/book.dart';

class _K {
  static const ns = "/library/browse";
  static const browseHistory = "$ns/browseHistory";
  static const favorite = "$ns/favorite";
}

class LibraryBrowseStorage {
  Box get box => HiveInit.library;

  const LibraryBrowseStorage();

  /// a list of book ID
  List<String>? getBrowseHistory() => box.get(_K.browseHistory);

  /// a list of book ID
  Future<void> setBrowseHistory(String bookId, List<String>? value) => box.put(_K.browseHistory, value);


  /// a list of book ID
  List<String>? getFavorite() => box.get(_K.favorite);

  /// a list of book ID
  Future<void> setFavorite(String bookId, List<String>? value) => box.put(_K.favorite, value);
}
