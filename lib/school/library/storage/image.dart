import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/hive.dart';

import '../entity/image.dart';

class _K {
  static const ns = "/library/images";

  static String image(String isbn) => "$ns/$isbn";
}

class LibraryImageStorage {
  Box get box => HiveInit.library;

  const LibraryImageStorage();

  BookImage? getImage(String isbn) => box.safeGet<BookImage>(_K.image(isbn));

  Future<void> setImage(String isbn, BookImage? value) => box.safePut<BookImage>(_K.image(isbn), value);
}
