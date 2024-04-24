import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/collection.dart';
import 'package:sit/utils/json.dart';
import '../entity/search.dart';

class _K {
  static const ns = "/search";
  static const searchHistory = "$ns/searchHistory";
  static const trends = "$ns/trends";
}

class LibrarySearchStorage {
  Box get box => HiveInit.library;

  const LibrarySearchStorage();

  LibraryTrends? getTrends() => decodeJsonObject(box.safeGet<String>(_K.trends), (obj) => LibraryTrends.fromJson(obj));

  Future<void> setTrends(LibraryTrends value) => box.safePut<String>(_K.trends, encodeJsonObject(value));

  List<SearchHistoryItem>? getSearchHistory() =>
      decodeJsonList(box.safeGet<String>(_K.searchHistory), (obj) => SearchHistoryItem.fromJson(obj));

  Future<void> setSearchHistory(List<SearchHistoryItem>? value) => box.safePut<String>(_K.searchHistory, encodeJsonList(value));

  ValueListenable<Box> listenSearchHistory() => box.listenable(keys: [_K.searchHistory]);
}

extension LibrarySearchStorageX on LibrarySearchStorage {
  Future<void> addSearchHistory(SearchHistoryItem item) async {
    final all = getSearchHistory() ?? <SearchHistoryItem>[];
    all.add(item);
    all.sort((a, b) => b.time.compareTo(a.time));
    all.distinctBy((item) => item.keyword);
    await setSearchHistory(all);
  }
}
