import 'package:easy_localization/easy_localization.dart';

enum SearchMethod {
  any,
  title,
  primaryTitle,
  isbn,
  author,
  subject,
  $class,
  bookId,
  orderNumber,
  publisher,
  callNumber;

  String l10nName() => "library.searchMethod.$name".tr();
}

enum SortMethod {
  // 匹配度
  matchScore,
  // 出版日期
  publishDate,
  // 主题词
  subject,
  // 标题名
  title,
  // 作者
  author,
  // 索书号
  callNo,
  // 标题名拼音
  pinyin,
  // 借阅次数
  loanCount,
  // 续借次数
  renewCount,
  // 题名权重
  titleWeight,
  // 正题名权重
  titleProperWeight,
  // 卷册号
  volume;

  String l10nName() => "library.sortMethod.$name".tr();
}

enum SortOrder {
  asc,
  desc,
}
