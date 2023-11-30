import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';
import '../entity/search.dart';

class SearchHistoryStorage {
  Box get box => HiveInit.library;

  const SearchHistoryStorage();

  void add(SearchHistoryItem item) {
    // box.put(item.keyword.hashCode, item);
  }

  /// 根据搜索文字删除
  void delete(String record) {
    box.delete(record.hashCode);
  }

  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  /// 按时间降序获取所有
  List<SearchHistoryItem> getAllByTimeDesc() {
    var result = box.values.toList();
    result.sort((a, b) => b.time.compareTo(a.time));
    return result.cast<SearchHistoryItem>();
  }
}
