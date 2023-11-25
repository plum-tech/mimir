import 'package:flutter/foundation.dart';
import 'package:sit/school/library/service/holding_preview.dart';
import 'package:sit/school/library/service/image_search.dart';

import 'entity/book_image.dart';
import 'entity/book.dart';
import 'entity/holding_preview.dart';
import 'init.dart';

class BookImageHolding {
  Book book;
  BookImage? image;
  List<HoldingPreviewItem>? holding;

  BookImageHolding(this.book, {this.image, this.holding});

  /// 使得图书列表,图书图片信息,馆藏信息相关联
  static List<BookImageHolding> build(
    List<Book> books,
    Map<String, BookImage> imageMap,
    Map<String, List<HoldingPreviewItem>> holdingMap,
  ) {
    return books.map((book) {
      return BookImageHolding(
        book,
        image: imageMap[book.isbn.replaceAll('-', '')],
        holding: holdingMap[book.bookId],
      );
    }).toList();
  }

  /// 可以很简单地并发查询一批书的图片与馆藏信息并join出结果
  static Future<List<BookImageHolding>> simpleQuery(
    List<Book> books, // 图书搜索结果
  ) async {
    Future<Map<String, BookImage>> searchBookImages() async {
      try {
        debugPrint('批量查询图书图片信息');
        final isbnList = books.map((e) => e.isbn).toList();
        return await LibraryInit.bookImageSearch.searchByIsbnList(isbnList);
      } catch (e) {
        // 查询出错
        debugPrint('查询图书图片信息错误: $e');
        return {};
      }
    }

    Future<HoldingPreviews> getHoldingPreviews() async {
      try {
        debugPrint('批量获取馆藏信息');
        final bookIdList = books.map((e) => e.bookId).toList();
        return await LibraryInit.holdingPreview.getHoldingPreviews(bookIdList);
      } catch (e) {
        // 查询出错
        debugPrint('获取馆藏信息出错: $e');
        return const HoldingPreviews({});
      }
    }

    final imageHoldingPreview = await Future.wait([
      searchBookImages(),
      getHoldingPreviews(),
    ]);
    final imageResult = imageHoldingPreview[0] as Map<String, BookImage>;
    final holdingPreviewResult = imageHoldingPreview[1] as HoldingPreviews;
    return BookImageHolding.build(
      books,
      imageResult,
      holdingPreviewResult.previews,
    );
  }
}
