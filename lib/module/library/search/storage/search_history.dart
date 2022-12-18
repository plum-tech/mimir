import '../../using.dart';
import '../dao/search_history.dart';
import '../entity/search_history.dart';

class SearchHistoryStorage implements SearchHistoryDao {
  final Box<LibrarySearchHistoryItem> box;

  const SearchHistoryStorage(this.box);

  @override
  void add(LibrarySearchHistoryItem item) {
    box.put(item.keyword.hashCode, item);
  }

  /// 根据搜索文字删除
  @override
  void delete(String record) {
    box.delete(record.hashCode);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  /// 按时间降序获取所有
  @override
  List<LibrarySearchHistoryItem> getAllByTimeDesc() {
    var result = box.values.toList();
    result.sort((a, b) => b.time.compareTo(a.time));
    return result;
  }
}
