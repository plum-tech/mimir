import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonEnum()
enum SearchMethod {
  any(""),
  title("title"),
  primaryTitle("title200a"),
  isbn("isbn"),
  author("author"),
  subject("subject"),
  $class("class"),
  bookId("ctrlno"),
  orderNumber("orderno"),
  publisher("publisher"),
  callNumber("callno");

  final String internalQueryParameter;

  const SearchMethod(this.internalQueryParameter);

  String l10nName() => "library.searchMethod.$name".tr();
}

@JsonEnum()
enum SortMethod {
  // 匹配度
  matchScore("score"),
  // 出版日期
  publishDate("pubdate_sort"),
  // 主题词
  subject("subject_sort"),
  // 标题名
  title("title_sort"),
  // 作者
  author("author_sort"),
  // 索书号
  callNo("callno_sort"),
  // 标题名拼音
  pinyin("pinyin_sort"),
  // 借阅次数
  loanCount("loannum_sort"),
  // 续借次数
  renewCount("renew_sort"),
  // 题名权重
  titleWeight("title200Weight"),
  // 正题名权重
  primaryTitleWeight("title200aWeight"),
  // 卷册号
  volume("title200h");

  final String internalQueryParameter;

  const SortMethod(this.internalQueryParameter);

  String l10nName() => "library.sortMethod.$name".tr();
}

@JsonEnum()
enum SortOrder {
  asc("asc"),
  desc("desc");

  final String internalQueryParameter;

  const SortOrder(this.internalQueryParameter);
}

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
    return {
      "keyword": keyword,
      "searchMethod": searchMethod,
      "time": time,
    }.toString();
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) => _$SearchHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryItemToJson(this);
}

@JsonSerializable()
class LibraryTrendsItem {
  @JsonKey()
  final String keyword;
  @JsonKey()
  final int count;

  const LibraryTrendsItem({
    required this.keyword,
    required this.count,
  });

  @override
  String toString() {
    return "$keyword($count)";
  }

  factory LibraryTrendsItem.fromJson(Map<String, dynamic> json) => _$LibraryTrendsItemFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryTrendsItemToJson(this);
}

@JsonSerializable()
class LibraryTrends {
  @JsonKey()
  final List<LibraryTrendsItem> recent30days;
  @JsonKey()
  final List<LibraryTrendsItem> total;

  const LibraryTrends({
    required this.recent30days,
    required this.total,
  });

  @override
  String toString() {
    return {
      "recent30days": recent30days,
      "total": total,
    }.toString();
  }

  factory LibraryTrends.fromJson(Map<String, dynamic> json) => _$LibraryTrendsFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryTrendsToJson(this);
}
