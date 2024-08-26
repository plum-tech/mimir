import 'package:hive/hive.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/storage/hive/init.dart';

class _K {
  static const ns = "/library/browse";
  static const browseHistory = "$ns/browseHistory";
  static const favorite = "$ns/favorite";
}

class LibraryBrowseStorage {
  Box get box => HiveInit.library;

  const LibraryBrowseStorage();

  /// a list of book ID
  List<String>? getBrowseHistory() => box.safeGet<List>(_K.browseHistory)?.cast<String>();

  /// a list of book ID
  Future<void> setBrowseHistory(String bookId, List<String>? value) => box.safePut<List>(_K.browseHistory, value);

  /// a list of book ID
  List<String>? getFavorite() => box.safeGet<List>(_K.favorite)?.cast<String>();

  /// a list of book ID
  Future<void> setFavorite(String bookId, List<String>? value) => box.safePut<List>(_K.favorite, value);
}
