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

import '../entity/borrow.dart';

abstract class LibraryBorrowDao {
  /// 获取用户的借阅记录
  Future<List<BorrowBookItem>> getMyBorrowBookList(int page, int rows);

  /// 续借图书
  Future<String> renewBook({
    required List<String> barcodeList,
    bool renewAll = false,
  });

  /// 用户的历史借阅情况
  Future<List<HistoryBorrowBookItem>> getHistoryBorrowBookList(int page, int rows);
}
