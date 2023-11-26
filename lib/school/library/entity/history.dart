import 'package:json_annotation/json_annotation.dart';
import 'package:sit/hive/type_id.dart';
import 'package:sit/school/library/entity/search.dart';

part 'history.g.dart';

@JsonSerializable()
class SearchHistoryItem {
  @JsonKey()
  final String keyword;
  @JsonKey()
  final SearchMethod searchMethod;
  @JsonKey()
  final DateTime time;

  SearchHistoryItem({
    required this.keyword,
    required this.searchMethod,
    required this.time,
  });

  @override
  String toString() {
    return 'SearchHistoryItem{keyword: $keyword, time: $time}';
  }
}
