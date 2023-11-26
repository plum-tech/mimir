import 'package:easy_localization/easy_localization.dart';

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

enum SortOrder {
  asc("asc"),
  desc("desc");

  final String internalQueryParameter;

  const SortOrder(this.internalQueryParameter);
}
