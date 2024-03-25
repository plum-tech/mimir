import 'package:hive/hive.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/storage/hive/init.dart';

class _K {
  static const ns = "/library/browse";
  static const browseHistory = "$ns/browseHistory";
  static const favorite = "$ns/favorite";
}

class LibraryBrowseStorage {
  Box get box => HiveInit.library;

  const LibraryBrowseStorage();

  /// a list of book ID
  List<String>? getBrowseHistory() => (box.safeGet(_K.browseHistory) as List<dynamic>?)?.cast<String>();

  /// a list of book ID
  Future<void> setBrowseHistory(String bookId, List<String>? value) => box.safePut(_K.browseHistory, value);

  /// a list of book ID
  List<String>? getFavorite() => (box.safeGet(_K.favorite) as List<dynamic>?)?.cast<String>();

  /// a list of book ID
  Future<void> setFavorite(String bookId, List<String>? value) => box.safePut(_K.favorite, value);
}
