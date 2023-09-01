/*
 *
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
/// 借书记录
class BorrowBookItem {
  /// 图书号
  String bookId = '';

  /// 条码号
  String barcode = '';

  String isbn = '';

  String author = '';

  /// 题名
  String title = '';

  /// 索书号
  String callNo = '';

  /// 馆藏地点
  String location = '';

  /// 图书类型
  String type = '';

  /// 借出日期
  DateTime borrowDate = DateTime.now();

  /// 应还日期
  DateTime expireDate = DateTime.now();

  @override
  String toString() {
    return 'BorrowBookItem{bookId: $bookId, barcode: $barcode, isbn: $isbn, author: $author, title: $title, callNo: $callNo, location: $location, type: $type, borrowDate: $borrowDate, expireDate: $expireDate}';
  }
}

/// 历史借书记录
class HistoryBorrowBookItem {
  /// 图书号
  String bookId = '';

  /// 操作类型
  String operateType = '';

  /// 条码号
  String barcode = '';

  /// 题名
  String title = '';

  String isbn = '';

  /// 索书号
  String callNo = '';

  /// 馆藏地点
  String location = '';

  /// 图书类型
  String type = '';

  /// 著者
  String author = '';

  /// 处理日期
  DateTime processDate = DateTime.now();

  @override
  String toString() {
    return 'HistoryBorrowBookItem{bookId: $bookId, operateType: $operateType, barcode: $barcode, title: $title, isbn: $isbn, callNo: $callNo, location: $location, type: $type, author: $author, processDate: $processDate}';
  }
}
