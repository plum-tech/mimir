import '../../using.dart';

part 'search_history.g.dart';

@HiveType(typeId: HiveTypeId.librarySearchHistory)
class LibrarySearchHistoryItem extends HiveObject {
  @HiveField(0)
  String keyword = '';

  @HiveField(1)
  DateTime time = DateTime.now();

  @override
  String toString() {
    return 'SearchHistoryItem{keyword: $keyword, time: $time}';
  }
}
