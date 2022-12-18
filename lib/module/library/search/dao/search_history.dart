import '../entity/search_history.dart';

abstract class SearchHistoryDao {
  // 添加搜索记录
  void add(LibrarySearchHistoryItem item);

  // 删除指定搜索记录
  void delete(String record);

  // 删除所有搜索记录
  void deleteAll();

  // 按时间降序获取所有搜索记录
  List<LibrarySearchHistoryItem> getAllByTimeDesc();
}
